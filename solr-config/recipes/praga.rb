node[:deploy].each do |app_name, deploy|
  env = deploy[:rails_env]
  
  remote_directory "/opt/solr/server/solr/#{node[:search][env][:core_name]}" do
    files_mode '0640'
    mode '0770'
    owner 'deploy'
    source "cores/#{node[:search][env][:core_name]}"
  end

  #template "/opt/solr/server/solr/#{node[:search][env][:core_name]}/conf/data-config.xml" do
  #  source "cores/data-config.xml.erb"
  #  owner deploy[:user]
  #  group 'www-data'
  #  mode 0440
  #  variables({ :driver => node[:search][env][:drive],
  #              :url => node[:search][env][:url],
  #              :password => node[:search][env][:password],
  #              :user => node[:search][env][:user],
  #              :query => node[:search][env][:query],
  #              :deltaImportQuery => node[:search][env][:deltaImportQuery],
  #              :deltaQuery => node[:search][env][:deltaQuery]})
  #end

  #template "/opt/solr/server/solr/#{node[:search][env][:core_name]}/conf/solrconfig.xml" do
  #  source "cores/solrconfig.xml.erb"
  #  owner deploy[:user]
  #  group 'www-data'
  #  mode 0440
  #  variables({ :name => node[:search][env][:core_name]})
  #end

  #template "/opt/solr/server/solr/#{node[:search][env][:core_name]}/core.properties" do
  #  source "cores/core.properties.erb"
  #  owner deploy[:user]
  #  group 'www-data'
  #  mode 0440
  #  variables({ :name => node[:search][env][:core_name]})
  #end

  execute '/opt/solr/bin/solr restart' do
    user "deploy"
  end

end

