node[:deploy].each do |app_name, deploy|
  template "/opt/solr/server/solr/conf/#{node[:search]["staging"][:core_name]}/conf/data-config.xml" do
    source "cores/data-config.xml"
    owner deploy[:user]
    group 'www-data'
    mode 0440
    variables({ :driver => default[:search]["staging"][:drive],
                :url => default[:search]["staging"][:url],
                :password => default[:search]["staging"][:password],
                :user => default[:search]["staging"][:user],
                :query => default[:search]["staging"][:query],
                :deltaImportQuery => default[:search]["staging"][:deltaImportQuery],
                :deltaQuery => default[:search]["staging"][:deltaQuery]})
  end

  template "/opt/solr/server/solr/conf/#{node[:search]["staging"][:core_name]}/core.properties" do
    source "cores/data-config.xml"
    owner deploy[:user]
    group 'www-data'
    mode 0440
    variables({ :name => node[:search]["staging"][:core_name]})
  end



end

