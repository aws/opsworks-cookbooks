include_recipe "apache2::service"

service "apache2" do
  action :stop
end