use_inline_resources

action :mount do
  real_device_name = if EbsVolumeHelpers.nvme_based?
                       EbsVolumeHelpers.device_name(new_resource.volume_id)
                     else
                       new_resource.device.gsub(/sd/, "xvd")
                     end

  execute "mkfs #{real_device_name}" do
    command "mkfs -t #{new_resource.fstype} #{real_device_name}"

    only_if do
      BlockDevice.wait_for(real_device_name)

      # check volume filesystem
      command = "blkid -s TYPE -o value #{real_device_name}"
      cmd = Mixlib::ShellOut.new(command)
      cmd.run_command
      !Array(cmd.valid_exit_codes).include?(cmd.exitstatus)
    end
  end

  directory new_resource.mount_point do
    recursive true
    action :create
    mode "0755"
  end

  ruby_block 'delete existing fstab entries for this mount point and device' do
    block do
      file = Chef::Util::FileEdit.new('/etc/fstab')
      file.search_file_delete_line(new_resource.mount_point)
      file.search_file_delete_line(real_device_name)
      file.write_file
    end
  end

  mount new_resource.mount_point do
    action [:mount, :enable]
    fstype new_resource.fstype || "auto"
    device real_device_name
    options value_for_platform(
                %w(debian ubuntu) => { "default" => "relatime,nobootwait", "16.04" => nil },
                "default" => "relatime"
            )
    pass 0
  end
end