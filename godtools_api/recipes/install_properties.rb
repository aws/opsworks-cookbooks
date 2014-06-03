directory '/apps' do
  mode 0755
  action :create
end

directory '/apps/apps-config' do
  mode 0755
  action :create
end

template '/apps/apps-config/godtools-api-properties.xml' do
  mode 0744
  backup false
  source 'godtools_api_properties.xml.erb'
  action :create
end