  execute 'create alpha tomcat server' do
    action :run
    command "tomcat7-instance-create -p 8081 -c 8006 /opt/athleticoffice/servers/alpha"
  end
  
    execute 'create omega tomcat server' do
    action :run
    command "tomcat7-instance-create -p 8082 -c 8007 /opt/athleticoffice/servers/omega"
  end

['alpha','omega'].each do |server|
template "/opt/athleticoffice/servers/#{server}/conf/server.xml" do
  source "servers/#{server}.xml.erb"
  owner 'root'
  group 'root'
  mode 0755
  backup false
end
template "/etc/init.d/#{server}" do
  source "servers/startup-script.erb"
  variables({
    :x_server => "#{server}"
  })
end
 execute 'copy tomcat server bin' do
    action :run
    command "cp -R /usr/share/tomcat7/bin /opt/athleticoffice/servers/#{server}"
  end
   execute 'copy tomcat conf policy' do
    action :run
    command "cp -R /etc/tomcat7/policy.d /opt/athleticoffice/servers/#{server}/conf"
  end
end

  
    execute 'download solr' do
    action :run
    cwd "/opt/athleticoffice/solr"
    command "wget http://www.springblox.com/wp-content/uploads/solr-4.6.1_01.tgz"
  end
  
  execute 'install solr' do
    action :run
    cwd "/opt/athleticoffice/solr"
    command "tar -zxvf solr-4.6.1_01.tgz"
  end

template "/opt/athleticoffice/solr/solr-4.6.1_01/example/example-DIH/solr/solr/conf/schema.xml" do
  source "schema.xml.erb"
  owner 'root'
  group 'root'
  mode 0644
  backup false
end
