include_recipe "scalarium_ganglia::client"


package "gmetad"

# install old ganglia frontend to bring in all dependencies
package "ganglia-webfrontend"
package "ganglia-webfrontend" do
  action :remove
end

include_recipe 'scalarium_ganglia::service-gmetad'

service "gmetad" do
  action :stop
end

include_recipe 'scalarium_ganglia::bind-mount-data'

template "/etc/ganglia/gmetad.conf" do
  mode '644'
  source "gmetad.conf.erb"
  variables :cluster_name => node[:scalarium][:cluster][:name]
end

include_recipe 'scalarium_ganglia::custom-install'
include_recipe 'apache2::service'

service "gmetad" do
  action [ :enable, :start ]
end

service "apache2" do
  action :restart
end
