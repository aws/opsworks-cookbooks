%w[ /apps /apps/apps-config ].each do |path|
  directory path do
    mode 0755
    action :create
  end
end

template '/apps/apps-config/godtools-api-properties.xml' do
  mode 0744
  backup false
  source 'godtools_api_properties.xml.erb'
  action :create
end