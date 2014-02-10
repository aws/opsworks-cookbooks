  execute 'create alpha tomcat server' do
    action :run
    command "tomcat7-instance-create -p 8081 -c 8006 /opt/athleticoffice/servers/alpha"
  end
  
    execute 'create omega tomcat server' do
    action :run
    command "tomcat7-instance-create -p 8082 -c 8007 /opt/athleticoffice/servers/omega"
  end


  bin_dir = ::File.join('/usr/share/tomcat7', 'bin')
  server_bin_dir = ::File.join('/opt/athleticoffice/servers/alpha', 'bin')


  link server_bin_dir do
    to bin_dir
    action :create
  end
