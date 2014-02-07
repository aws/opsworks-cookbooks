user 'wildfly' do

  :create
end

remote_file '/opt/wildfly-' + node['wildfly']['version'] + '.tar.gz' do
  source 'http://download.jboss.org/wildfly/' + node['wildfly']['version'] + '/wildfly-' + node['wildfly']['version'] + '.tar.gz'
  mode 0744
  owner node['wildfly']['user']
  group node['wildfly']['group']
end

execute 'unpack-wildfly' do
  cwd "/opt"
  command "tar -zxf wildfly-" + node['wildfly']['version'] + ".tar.gz"
  action :run
end

execute 'chown-wildfly' do
  cwd '/opt'
  command 'chown -R wildfly:wildfly /opt/wildfly-' + node['wildfly']['version']
end
include_recipe 'wildfly::wildfly_service'
