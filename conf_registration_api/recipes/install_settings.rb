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

template '/apps/apps-config/conf_registration_api-settings.xml' do
  owner 'wildfly'
  group 'wildfly'
  mode 0744
  backup false
  source 'conf_registration_api_settings.xml.erb'
  action :create
end