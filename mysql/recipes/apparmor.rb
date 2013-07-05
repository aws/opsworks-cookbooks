service "apparmor" do
  supports :status => true, :restart => true, :reload => true
  action :nothing
  ignore_failure true
end

# allow MySQL to read /sys/devices/system/cpu/*
template "/etc/apparmor.d/usr.sbin.mysqld" do
  source "apparmor.mysql.erb"
  backup false
  owner 'root'
  group 'root'
  mode '0644'
  only_if do
    system("service apparmor status") && File.exists?("/etc/apparmor.d/usr.sbin.mysqld")
  end
  notifies :restart, "service[apparmor]", :immediately
end