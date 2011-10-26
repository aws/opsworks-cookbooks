
package "monit"

directory "/etc/monit/conf.d" do
  group "root"
  owner "root"
  action :create
  recursive true
end

include_recipe "scalarium-agent-monit::service"

template "/etc/default/monit" do
  source "monit.erb"
  mode 0644
end

template "/etc/monit/monitrc" do
  source "monitrc.erb"
  mode 0644
  notifies :restart, resources(:service => "monit")
end

template "/etc/monit/conf.d/scalarium_agent.monitrc" do
  source "scalarium_agent.monitrc.erb"
  mode 0644
  notifies :restart, resources(:service => "monit")
end

service "monit" do
  action :restart
end
