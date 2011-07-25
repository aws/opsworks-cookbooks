if File.exists?("/etc/init.d/nginx")
  include_recipe "nginx::service"

  service "nginx" do
    action :stop
  end

  package "nginx" do
    action :remove
  end
end