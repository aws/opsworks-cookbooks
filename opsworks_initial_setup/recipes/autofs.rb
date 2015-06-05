package "autofs"

service "autofs" do
  if node['platform'] == 'ubuntu'
    provider Chef::Provider::Service::Upstart
  end
  supports :status => true, :restart => false, :reload => true
  action [ :enable, :start ]
end

template node[:opsworks_initial_setup][:autofs_map_file] do
  source "automount.opsworks.erb"
  mode "0444"
  owner "root"
  group "root"
end

ruby_block "Update autofs loglevel" do
  block do
    handle_to_master = Chef::Util::FileEdit.new(AutoFs.config(node))
    handle_to_master.insert_line_if_no_match(
      /^LOGGING=/,
      "LOGGING=verbose"
    )
    handle_to_master.write_file
  end
  not_if { ::File.read(AutoFs.config(node)) =~ /^LOGGING=/ }
end

ruby_block "Update autofs configuration" do
  block do
    handle_to_master = Chef::Util::FileEdit.new("/etc/auto.master")
    handle_to_master.insert_line_if_no_match(
      node[:opsworks_initial_setup][:autofs_map_file],
      "/- #{node[:opsworks_initial_setup][:autofs_map_file]} -t 3600 -n 1"
    )
    handle_to_master.write_file
  end
  notifies :restart, "service[autofs]", :immediately
  not_if { ::File.read('/etc/auto.master').include?('auto.opsworks') }
end
