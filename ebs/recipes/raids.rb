package 'mdadm'
package 'lvm2'

execute 'Load device mapper kernel module' do
  command 'modprobe dm-mod'
  ignore_failure true
end

node.set[:ebs][:raids].each do |raid_device, options|
  Chef::Log.info "Processing RAID #{raid_device} with options #{options} "
  lvm_device = BlockDevice.lvm_device(raid_device)

  Chef::Log.info("Waiting for individual disks of RAID #{options[:mount_point]}")
  options[:disks].each do |disk_device|
    BlockDevice::wait_for(disk_device)
  end

  execute "mkfs_#{lvm_device}" do
    command "test \"$(blkid -s TYPE -o value #{lvm_device})\" = \"#{options[:fstype]}\" || mkfs -t #{options[:fstype]} #{lvm_device}"
    action :nothing
  end

  ruby_block "Create or attach LVM volume out of #{raid_device}" do
    block do
      BlockDevice.create_lvm(raid_device, options)
      BlockDevice.wait_for(lvm_device)
    end
    action :nothing
    notifies :run, "execute[mkfs_#{lvm_device}]", :immediately
  end

  ruby_block "Create or resume RAID array #{raid_device}" do
    block do
      if BlockDevice.existing_raid_at?(raid_device)
        if BlockDevice.assembled_raid_at?(raid_device)
          Chef::Log.info "Skipping RAID array at #{raid_device} - already assembled and probably mounted at #{options[:mount_point]}"
        else
          BlockDevice.assemble_raid(raid_device, options)
        end
      else
        BlockDevice.create_raid(raid_device, options.update(:chunk_size => node[:ebs][:mdadm_chunk_size]))
      end
      BlockDevice.set_read_ahead(raid_device, node[:ebs][:md_read_ahead])
    end
    notifies :create, "ruby_block[Create or attach LVM volume out of #{raid_device}]", :immediately
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
      File.read('/etc/mtab').split("\n").any? do |line|
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

  template 'mdadm configuration' do
    path value_for_platform(
      ['centos','redhat','fedora','amazon'] => {'default' => '/etc/mdadm.conf'},
      'default' => '/etc/mdadm/mdadm.conf'
    )
    source 'mdadm.conf.erb'
    mode 0644
    owner 'root'
    group 'root'
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
