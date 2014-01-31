remote_file '/opt/wildfly-8.0.0.CR1.tar.gz' do
  source "http://download.jboss.org/wildfly/8.0.0.CR1/wildfly-8.0.0.CR1.tar.gz"
end

execute 'change-ownership' do
  cwd "/opt"
  command "chown wildfly:wildfly wildfly-8.0.0.CR1.tar.gz"
  action :run
end

execute 'unpack-wildfly' do
  cwd "/opt"
  command "tar -zxf wildfly-8.0.0.CR1.tar.gz"
  action :run
end