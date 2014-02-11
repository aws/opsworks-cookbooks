  execute 'create alpha tomcat server' do
    action :run
    command "tomcat7-instance-create -p 8081 -c 8006 /opt/athleticoffice/servers/alpha"
  end
  
    execute 'create omega tomcat server' do
    action :run
    command "tomcat7-instance-create -p 8082 -c 8007 /opt/athleticoffice/servers/omega"
  end

['alpha','omega'].each do |server|
template '#{server} server configuration' do
  path ::File.join('/opt/athleticoffice/servers/#{server}/conf', 'server.xml')
  source 'servers/#{server}.xml.erb'
  owner 'root'
  group 'root'
  mode 0644
  backup false
end
end

['alpha','omega'].each do |server|
template '/etc/init.d/#{server}' do
  source 'servers/startup-script.erb'
  variables({
    :x_server => '#{server}'
  })
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

