directory "#{node[:ganglia][:datadir]}/rrds" do
  owner node[:ganglia][:rrds_user]
  mode "0775"
  recursive true
  action :create
end

ruby_block "Update autofs configuration for ganglia" do
  block do
    handle_to_map_file = Chef::Util::FileEdit.new(node[:opsworks_initial_setup][:autofs_map_file])
    handle_to_map_file.insert_line_if_no_match(node[:ganglia][:datadir], node[:ganglia][:autofs_entry])
    handle_to_map_file.write_file
  end

  notifies :restart, "service[autofs]", :immediately
end
