directory '/apps' do
  owner 'wildfly'
  group 'wildfly'
  mode 0744
  action :create
end

directory '/apps/apps-config' do
  owner 'wildfly'
  group 'wildfly'
  mode 0744
  action :create
end

template '/apps/apps-config/conf-registration-api-settings.xml' do
  owner 'wildfly'
  group 'wildfly'
  mode 0744
  backup false
  source 'conf-registration-api-settings.xml.erb'
  action :create
end