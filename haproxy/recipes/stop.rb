include_recipe "haproxy::service"

service "haproxy" do
  action :stop
end