node[:deploy].each do |app_name, deploy|
  env = deploy[:rails_env]

  remote_directory "#{node[:nca][env][:path]}/#{node[:nca][env][:core_name]}" do
    files_mode '0640'
    files_owner 'deploy'
    mode '0770'
    owner 'deploy'
    recursive true
    source "cores/#{node[:nca][env][:core_name]}"
  end

  service 'solr' do
    supports :restart => true, :status => true
    action [:enable, :start]
  end


  template "/etc/logrotate.d/solr" do
    source "cores/logrotate.erb"
    owner 'root'
    group 'root'
    mode 0644
    variables(:log_dirs => "#{node['default'][env]['root']}/log",
              :bin_dir => "#{node['default'][env]['root']}/bin"
            )
  end
  
end
