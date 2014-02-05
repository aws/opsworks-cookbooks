directory 'tmp/artifacts' do
  owner node['wildfly']['user']
  group node['wildfly']['group']
  mode 0744
  action :create
end

directory '/tmp/artifacts/crs-api' do
  owner node['wildfly']['user']
  group node['wildfly']['group']
  mode 0744
  action :create
end

git '/tmp/artifacts/crs-api' do
  depth 5
  repository 'git@github.com:CruGlobal/conf-registration-api.git'
  revision 'mvn-repo'
end

execute 'move file to server' do
  command 'mv *.war /opt/wildfly-' + node['wildfly']['version'] + '/standalone/deployments/crs-http-json-api.war'
  cwd '/tmp/artifacts/crs-api/conf-registration-api/org/cru/crs-http-json-api/' + node['crs-api']['version']
  user node['wildfly']['user']
  group node['wildfly']['group']
end