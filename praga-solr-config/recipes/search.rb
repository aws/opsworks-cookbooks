node[:deploy].each do |app_name, deploy|

  Chef::Log.info(deploy)

  env = deploy[:rails_env]

  Chef::Log.info(env)
  remote_directory "/mnt/var/solr/#{node[:search][env][:core_name]}" do
  # /opt/solr/server/solr/#{node[:search][env][:core_name]}" do
    files_mode '0640'
    files_owner 'deploy'
    mode '0770'
    owner 'deploy'
    recursive true
    source "cores/#{node[:search][env][:core_name]}"
  end

  template "/mnt/var/solr/#{node[:search][env][:core_name]}/conf/data-config.xml" do
    source "cores/data-config.xml.erb"
    owner deploy[:user]
    group 'www-data'
    mode 0440
    variables({
      :driver => node[:search][env][:drive],
      :url => node[:search][env][:url],
      :password => node[:search][env][:password],
      :user => node[:search][env][:user],
      :query => node[:search][env][:query],
      :deltaImportQuery => node[:search][env][:deltaImportQuery],
      :deltaQuery => node[:search][env][:deltaQuery]
    })
  end

  template "/mnt/var/solr/#{node[:search][env][:core_name]}/core.properties" do
    source "cores/core.properties.erb"
    owner deploy[:user]
    group 'www-data'
    mode 0440
    variables({ :name => node[:search][env][:core_name]})
  end

  execute "ln -s /mnt/var/solr/#{node[:search][env][:core_name]} /opt/solr/server/solr/#{node[:search][env][:core_name]}"

  execute '/opt/solr/bin/solr restart' do
    user "deploy"
  end

end
