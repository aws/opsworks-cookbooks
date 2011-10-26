include_recipe "memcached::service"

service "memcached" do
  action :stop
end