node[:opsworks_initial_setup][:bind_mounts][:mounts].each do |dir, source|
  directory source do
    recursive true
    action :create
    mode "0755"
  end
end

bash "Enable selinux http_log target for apache log files" do
  path = "#{node[:opsworks_initial_setup][:bind_mounts][:mounts]["/var/log/httpd"]}(/.*)?"
  context = "httpd_log_t"
  user "root"
  code <<-EOH
    semanage fcontext --add --type #{context} "#{path}" && restorecon -v "#{node[:opsworks_initial_setup][:bind_mounts][:mounts]["/var/log/httpd"]}"
  EOH
  not_if { OpsWorks::ShellOut.shellout("/usr/sbin/semanage fcontext -l") =~ /#{Regexp.escape(path)}\s.*\ssystem_u:object_r:#{context}:s0/ }
  only_if { platform_family?("rhel") && ::File.exist?("/usr/sbin/getenforce") && OpsWorks::ShellOut.shellout("/usr/sbin/getenforce").strip == "Enforcing" }
end

include_recipe 'opsworks_initial_setup::autofs'
