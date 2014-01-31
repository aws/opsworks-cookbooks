remote_file '/home/ryancarlson/wildfly-8.0.0.CR1.tar.gz' do
  source "http://download.jboss.org/wildfly/8.0.0.CR1/wildfly-8.0.0.CR1.tar.gz"
  mode 0744
  owner "ryancarlson"
  group "ryancarlson"
end

execute 'unpack-wildfly' do
  cwd "/home/ryancarlson"
  command "tar -zxf wildfly-8.0.0.CR1.tar.gz"
  action :run
end

include_recipe 'wildfly::wildfly_service'