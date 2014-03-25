bash "create swap file #{node['opsworks_initial_setup']['swapfile_name']}" do
  user 'root'
  code <<-EOC
    dd if=/dev/zero of=#{node['opsworks_initial_setup']['swapfile_name']} bs=1M count=#{node['opsworks_initial_setup']['swapfile_size_mb']}
    mkswap #{node['opsworks_initial_setup']['swapfile_name']}
    chown root:root #{node['opsworks_initial_setup']['swapfile_name']}
    chmod 0600 #{node['opsworks_initial_setup']['swapfile_name']}
  EOC
  creates node['opsworks_initial_setup']['swapfile_name']
end

mount 'swap' do
  action :enable
  device node['opsworks_initial_setup']['swapfile_name']
  fstype 'swap'
end

bash 'activate all swap devices' do
  user 'root'
  code 'swapon -a'
end
