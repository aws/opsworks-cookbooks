include_recipe 'conf_registration_api::user'

directory 'tmp/artifacts' do
  owner node['crs-api']['user']
  group node['crs-api']['group']
  mode 0755
  action :create
end

directory '/tmp/artifacts/conf-registration-api' do
  owner node['crs-api']['user']
  group node['crs-api']['group']
  mode 0755
  action :create
end

directory '/tmp/artifacts/deploy' do
  owner node['crs-api']['user']
  group node['crs-api']['group']
  mode 0755
  action :create
end

git '/tmp/artifacts/conf-registration-api' do
  depth 5
  repository 'http://github.com/CruGlobal/conf-registration-api'
  revision 'mvn-repo'
  user node['crs-api']['user']
  group node['crs-api']['group']
end

execute 'rename war for deploy' do
  command 'mv *.war /tmp/artifacts/deploy/crs-http-json-api.war'
  cwd '/tmp/artifacts/conf-registration-api/org/cru/crs-http-json-api/' + node['crs-api']['version']
  user node['crs-api']['user']
  group node['crs-api']['group']
end

execute 'deploy war' do
  command 'cp crs-http-json-api.war /opt/wildfly-' + node['wildfly']['version'] + '/standalone/deployments/crs-http-json-api.war'
  cwd '/tmp/artifacts/deploy'
  user node['wildfly']['user']
  group node['wildfly']['group']
end