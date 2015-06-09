directory "#{node[:ganglia][:datadir]}/rrds" do
  owner node[:ganglia][:rrds_user]
  mode "0775"
  recursive true
  action :create
end

bash "Enable selinux httpd_sys_content_t target for ganglia data files" do
  path = "#{node[:ganglia][:datadir]}/rrds(/.*)?"
  context = "httpd_sys_content_t"
  user "root"
  code <<-EOH
    semanage fcontext --add --type #{context} "#{path}" && restorecon -rv "#{node[:ganglia][:datadir]}/rrds"
  EOH
  not_if { OpsWorks::ShellOut.shellout("/usr/sbin/semanage fcontext -l") =~ /#{Regexp.escape(path)}\s.*\ssystem_u:object_r:#{context}:s0/ }
  only_if { platform_family?("rhel") && ::File.exist?("/usr/sbin/getenforce") && OpsWorks::ShellOut.shellout("/usr/sbin/getenforce").strip == "Enforcing" }
end

ruby_block "Update autofs configuration for ganglia" do
  block do
    handle_to_map_file = Chef::Util::FileEdit.new(node[:opsworks_initial_setup][:autofs_map_file])
    handle_to_map_file.insert_line_if_no_match(node[:ganglia][:datadir], node[:ganglia][:autofs_entry])
    handle_to_map_file.write_file
  end

  notifies :restart, "service[autofs]", :immediately
end
