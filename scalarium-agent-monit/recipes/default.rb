package "monit"

directory node[:monit][:conf_dir] do
  group "root"
  owner "root"
  action :create
  recursive true
end

include_recipe "scalarium-agent-monit::service"

if platform?('debian','ubuntu')
  template "/etc/default/monit" do
    source "monit.erb"
    mode 0644
  end
end

template node[:monit][:conf] do
  source "monitrc.erb"
  mode 0600
  notifies :restart, resources(:service => "monit")
end

template File.join(node[:monit][:conf_dir], "opsworks-agent.monitrc") do
  source "opsworks-agent.monitrc.erb"
  mode 0644
  notifies :restart, resources(:service => "monit")
end

if platform?('centos','redhat','fedora','amazon')
  file File.join(node[:monit][:conf_dir], 'logging') do
    action :delete
  end
end
