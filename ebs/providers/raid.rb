use_inline_resources

action :create do
  disks = if EbsVolumeHelpers.nvme_based?
            new_resource.volume_ids.map { |volume_id| EbsVolumeHelpers.device_name(volume_id) }
          else
            new_resource.disks
          end

  options = {
    :fstype => new_resource.fstype,
    :mount_point => new_resource.mount_point,
    :raid_level => new_resource.raid_level,
    :size => new_resource.size,
    :disks => disks,
    :volume_ids => new_resource.volume_ids
  }

  Chef::Log.info "Processing RAID #{new_resource.raid_device} with options #{options} "
  lvm_device = BlockDevice.lvm_device(new_resource.raid_device)

  Chef::Log.info("Waiting for individual disks of RAID #{options[:mount_point]}")
  disks.each do |disk_device|
    BlockDevice::wait_for(disk_device)
  end

  execute "mkfs_#{lvm_device}" do
    command "test \"$(blkid -s TYPE -o value #{lvm_device})\" = \"#{options[:fstype]}\" || mkfs -t #{options[:fstype]} #{lvm_device}"
    action :nothing
  end

  ruby_block "Create or attach LVM volume out of #{new_resource.raid_device}" do
    block do
      BlockDevice.create_lvm(new_resource.raid_device, options)
      BlockDevice.wait_for(lvm_device)
    end
    action :nothing
    notifies :run, "execute[mkfs_#{lvm_device}]", :immediately
  end

  ruby_block "Create or resume RAID array #{new_resource.raid_device}" do
    block do
      if BlockDevice.existing_raid_at?(new_resource.raid_device)
        if BlockDevice.assembled_raid_at?(new_resource.raid_device)
          Chef::Log.info "Skipping RAID array at #{new_resource.raid_device} - already assembled and probably mounted at #{options[:mount_point]}"
        else
          BlockDevice.assemble_raid(new_resource.raid_device, options)
        end
      else
        BlockDevice.create_raid(new_resource.raid_device, options.update(:chunk_size => node[:ebs][:mdadm_chunk_size]))
      end
      BlockDevice.set_read_ahead(new_resource.raid_device, node[:ebs][:md_read_ahead])
    end
    notifies :create, "ruby_block[Create or attach LVM volume out of #{new_resource.raid_device}]", :immediately
  end

  directory options[:mount_point] do
    recursive true
    mode 0755
  end

  mount options[:mount_point] do
    fstype options[:fstype]
    device lvm_device
    options 'noatime'
    pass 0
    not_if do
      ::File.read('/etc/mtab').split("\n").any? do |line|
        line.match(" #{options[:mount_point]} ")
      end
    end
  end

  mount "fstab entry for #{options[:mount_point]}" do
    mount_point options[:mount_point]
    action :enable
    fstype options[:fstype]
    device lvm_device
    options 'noatime'
    pass 0
  end

  execute "update initramfs" do
    command value_for_platform_family(
              "rhel" => "dracut -H -f /boot/initramfs-#{node["kernel"]["release"]}.img #{node["kernel"]["release"]}",
              "debian" => "update-initramfs -u"
            )
    only_if do
      value_for_platform_family(
        "rhel" => find_executable0("dracut"),
        "debian" => find_executable0("update-initramfs")
      )
    end
    action :nothing
  end

  template "mdadm configuration" do
    path value_for_platform(
           ["centos","redhat","fedora","amazon"] => {"default" => "/etc/mdadm.conf"},
           "default" => "/etc/mdadm/mdadm.conf"
         )
    source "mdadm.conf.erb"
    mode 0644
    owner "root"
    group "root"
    notifies :run, "execute[update initramfs]", :immediately
  end

  template 'rc.local script' do
    path value_for_platform(
           ['centos','redhat','fedora','amazon'] => {'default' => '/etc/rc.d/rc.local'},
           'default' => '/etc/rc.local'
         )
    source 'rc.local.erb'
    mode 0755
    owner 'root'
    group 'root'
  end
end