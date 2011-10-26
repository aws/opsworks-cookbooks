include_recipe "scalarium-agent-monit::service"

service "monit" do
  action :stop
end