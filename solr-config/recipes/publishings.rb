node[:deploy].each do |app_name, deploy|

  Chef::Log.info(deploy)

  env = deploy[:rails_env].present? ?  deploy[:rails_env] : 'production'

  Chef::Log.info(env)

  remote_directory "#{node[:search][env][:path]}/#{node[:search][env][:core_name]}" do
    files_mode '0640'
    files_owner 'deploy'
    mode '0770'
    owner 'deploy'
    recursive true
    source "cores/#{node[:search][env][:core_name]}"
  end

  template "#{node[:search][env][:path]}/#{node[:search][env][:core_name]}/core.properties" do
    source "cores/core.properties.erb"
    owner deploy[:user]
    group 'www-data'
    mode 0440
    variables({ :name => node[:search][env][:core_name]})
  end


  service 'solr' do
    supports :restart => true, :status => true
    action [:enable, :start]
  end
end
