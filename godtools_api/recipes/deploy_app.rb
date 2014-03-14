include_recipe 'godtools_api::user'

directory 'tmp/artifacts' do
  owner node['godtools']['user']
  group node['godtools']['group']
  mode 0755
  action :create
end

directory '/tmp/artifacts/godtools-api' do
  owner node['godtools']['user']
  group node['godtools']['group']
  mode 0755
  action :create
end

directory '/tmp/artifacts/deploy' do
  owner node['godtools']['user']
  group node['godtools']['group']
  mode 0755
  action :create
end

git '/tmp/artifacts/godtools-api' do
  depth 2
  repository 'http://github.com/CruGlobal/godtools-api'
  revision 'mvn-repo'
  user node['godtools']['user']
  group node['godtools']['group']
end

execute 'rename war for deploy' do
  command 'mv *.war /tmp/artifacts/deploy/godtools-api.war'
  cwd '/tmp/artifacts/godtools-api/org/cru/godtools-api/' + node['godtools']['version']
  user node['godtools']['user']
  group node['godtools']['group']
end

execute 'deploy war' do
  command 'cp godtools-api.war /opt/wildfly-' + node['wildfly']['version'] + '/standalone/deployments/godtools-api.war'
  cwd '/tmp/artifacts/deploy'
  user node['wildfly']['user']
  group node['wildfly']['group']
end