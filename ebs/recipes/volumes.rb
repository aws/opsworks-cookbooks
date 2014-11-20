node[:ebs][:devices].each do |device, options|
  execute "mkfs_#{device}" do
    command "mkfs -t #{options[:fstype]} #{device}"

    not_if do
      BlockDevice::wait_for(device)

      # check volume filesystem
      system("blkid -s TYPE -o value #{device}")
    end
  end

  directory options[:mount_point] do
    recursive true
    action :create
    mode "0755"
  end

  mount options[:mount_point] do
    action [:mount, :enable]
    fstype options[:fstype]
    device device
    options value_for_platform_family(
      'rhel' => "noatime",
      'debian' => "noatime,nobootwait"
    )
    pass 0
  end

end
