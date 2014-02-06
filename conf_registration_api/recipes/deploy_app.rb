include_recipe 'conf_registration_api::user'

directory 'tmp/artifacts' do
  owner node['crs-api']['user']
  group node['crs-api']['group']
  mode 0755
  action :create
end

directory '/tmp/artifacts/crs-api' do
  owner node['crs-api']['user']
  group node['crs-api']['group']
  mode 0755
  action :create
end

git '/tmp/artifacts/crs-api' do
  depth 5
  repository 'http://github.com/CruGlobal/conf-registration-api'
  revision 'mvn-repo'
  user node['crs-api']['user']
  group node['crs-api']['group']
end

execute 'move file to server' do
  command 'mv *.war /opt/wildfly-' + node['wildfly']['version'] + '/standalone/deployments/crs-http-json-api.war'
  cwd '/tmp/artifacts/crs-api/org/cru/crs-http-json-api/' + node['crs-api']['version']
  user node['wildfly']['user']
  group node['wildfly']['group']
end