package "monit"

directory node[:monit][:conf_dir] do
  group "root"
  owner "root"
  action :create
  recursive true
end

include_recipe "opsworks_agent_monit::service"

if platform?('debian','ubuntu')
  template "/etc/default/monit" do
    source "monit.erb"
    mode 0644
  end
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
