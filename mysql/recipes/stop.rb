include_recipe "mysql::service"

service "mysql" do
  action :stop
end