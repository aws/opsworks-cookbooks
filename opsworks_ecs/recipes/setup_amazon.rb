package "docker" do
  retries 3
  retry_delay 5
end

service "docker" do
  action :start
end

package "ecs-init" do
  retries 3
  retry_delay 5
end

service "ecs" do
  action :start

  provider Chef::Provider::Service::Upstart
end
