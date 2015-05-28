package "monit"

directory node[:monit][:conf_dir] do
  group "root"
  owner "root"
  action :create
  recursive true
end

include_recipe "opsworks_agent_monit::service"
include_recipe "opsworks_agent_monit::reload_systemd"

if platform?('debian','ubuntu')
  template "/etc/default/monit" do
    source "monit.erb"
    mode 0644
  end
end

# if Monit is running under systemd modify its systemd
# configuration so that when stopped, systemd does not
# send the kill signal to all processes in the service's
# control group 
template "/lib/systemd/system/monit.service" do
  source "monit.service.erb"
  only_if {File.exists?('/lib/systemd/system/monit.service')}
  notifies :run, 'execute[systemctl-daemon-reload]', :immediately
end

service 'monit' do
  action :stop
end

template node[:monit][:conf] do
  source "monitrc.erb"
  mode 0600
  #TODO: This should only happen if the service is running, after rebooting
#  notifies :restart, resources(:service => "monit")
end

template File.join(node[:monit][:conf_dir], "opsworks-agent.monitrc") do
  source "opsworks-agent.monitrc.erb"
  mode 0644
  #TODO: This should only happen if the service is running, after rebooting
#  notifies :restart, resources(:service => "monit")
end

if platform?('centos','redhat','fedora','amazon')
  file File.join(node[:monit][:conf_dir], 'logging') do
    action :delete
  end
end
