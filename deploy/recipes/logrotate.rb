log_dirs = []

log_dirs = node[:deploy].values.map{|deploy| "#{deploy[:deploy_to]}/shared/log" }

template "/etc/logrotate.d/scalarium_apps" do
  backup false
  source "logrotate.erb"
  owner "root"
  group "root"
  mode 0644
  variables( :log_dirs => log_dirs )
  not_if do
    log_dirs.empty?
  end
end
