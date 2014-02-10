directory '/apps' do
  owner 'wildfly'
  group 'wildfly'
  mode 0755
  action :create
end

directory '/apps/apps-config' do
  owner 'wildfly'
  group 'wildfly'
  mode 0755
  action :create
end

template '/apps/apps-config/conf-registration-api-properties.xml' do
  owner 'wildfly'
  group 'wildfly'
  mode 0744
  backup false
  source 'conf_registration_api_properties.xml.erb'
  action :create
  
  notifies :restart, "service[wildfly]"
end
