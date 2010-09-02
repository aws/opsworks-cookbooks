
package "xfsprogs"
package "xfsdump"
package "xfslibs-dev"

node[:ebs][:devices].each do |device, options|
  execute "mkfs" do
    command "mkfs -t #{options[:fstype]} #{device}"
    
    not_if do
      # wait for the device
      loop do
        if File.blockdev?(device)
          Chef::Log.info("device #{device} ready")
          break
        else
          Chef::Log.info("device #{device} not ready - waiting")
          sleep 10
        end
      end
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
    fstype options[:fstype]
    device device
    options "noatime"
  end
  
  mount options[:mount_point] do
    action :enable
    fstype options[:fstype]
    device device
    options "noatime"
  end
  
end

