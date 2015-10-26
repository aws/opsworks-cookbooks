package "docker"

service "docker" do
  action :start
end

package "ecs-init"

service "ecs" do
  action :start

  provider Chef::Provider::Service::Upstart
end
