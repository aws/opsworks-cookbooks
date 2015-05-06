node[:deploy].each do |app_name, deploy|
  
  remote_directory "/opt/solr/server/solr/#{node[:search]["staging"][:core_name]}" do
    files_mode '0640'
    mode '0770'
    owner 'deploy'
    source "cores/#{node[:search]["staging"][:core_name]}"
  end

  template "/opt/solr/server/solr/#{node[:search]["staging"][:core_name]}/conf/data-config.xml" do
    source "cores/data-config.xml.erb"
    owner deploy[:user]
    group 'www-data'
    mode 0440
    variables({ :driver => node[:search]["staging"][:drive],
                :url => node[:search]["staging"][:url],
                :password => node[:search]["staging"][:password],
                :user => node[:search]["staging"][:user],
                :query => node[:search]["staging"][:query],
                :deltaImportQuery => node[:search]["staging"][:deltaImportQuery],
                :deltaQuery => node[:search]["staging"][:deltaQuery]})
  end

  template "/opt/solr/server/solr/#{node[:search]["staging"][:core_name]}/conf/solrconfig.xml" do
    source "cores/solrconfig.xml.erb"
    owner deploy[:user]
    group 'www-data'
    mode 0440
    variables({ :name => node[:search]["staging"][:core_name]})
  end

  template "/opt/solr/server/solr/#{node[:search]["staging"][:core_name]}/core.properties" do
    source "cores/core.properties.erb"
    owner deploy[:user]
    group 'www-data'
    mode 0440
    variables({ :name => node[:search]["staging"][:core_name]})
  end

  execute '/opt/solr/bin/solr restart' do
    user "deploy"
  end

end

