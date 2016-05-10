node[:deploy].each do |app_name, deploy|

  Chef::Log.info(deploy)

  env = deploy[:rails_env].present? ?  deploy[:rails_env] : 'production'

  Chef::Log.info(env)

  remote_directory "#{node[:seller_deals][env][:path]}/#{node[:seller_deals][env][:core_name]}" do
    files_mode '0640'
    files_owner 'deploy'
    mode '0770'
    owner 'deploy'
    recursive true
    source "cores/#{node[:seller_deals][env][:core_name]}"
  end

  template "#{node[:seller_deals][env][:path]}/#{node[:seller_deals][env][:core_name]}/core.properties" do
    source "cores/core.properties.erb"
    owner deploy[:user]
    group 'www-data'
    mode 0440
    variables({ :name => node[:seller_deals][env][:core_name]})
  end

  template "#{node['seller_deals'][env]['path']}/#{node['seller_deals'][env]['core_name']}/conf/data-config.xml" do
    source "cores/#{node['seller_deals'][env]['core_name']}/data-config.xml.erb"
    owner deploy[:user]
    group 'www-data'
    mode 0440
    variables({ :db_url => node['seller_deals'][env]['database_url'],
                :db_name => node['seller_deals'][env]['database_name'],
                :db_url => node['seller_deals'][env]['database_url'],
                :db_user => node['seller_deals'][env]['database_user'],
                :db_password => node['seller_deals'][env]['database_password']}
             )
  end

  service 'solr' do
    supports :restart => true, :status => true
    action [:enable, :start]
  end
end
