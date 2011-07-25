package "nginx" do
  notifies :stop, resources(:service => "apache2")
  action :remove
end