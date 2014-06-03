directory '/apps/apps-config' do
  mode 0755
  action :create
end

template '/apps/apps-config/conf-registration-api-properties.xml' do
  owner node['crs-api']['user']
  group node['crs-api']['group']
  mode 0744
  backup false
  source 'conf_registration_api_properties.xml.erb'
  action :create
  
end
