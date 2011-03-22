require 'resolv'

include_recipe "mysql::client"

case node[:platform]
when "debian","ubuntu"

  directory "/var/cache/local/preseeding" do
    owner "root"
    group "root"
    mode 0755
    recursive true
  end

  execute "preseed-mysql-server" do
    command "debconf-set-selections /var/cache/local/preseeding/mysql-server.seed"
    action :nothing
  end

  template "/var/cache/local/preseeding/mysql-server.seed" do
    source "mysql-server.seed.erb"
    backup false
    owner "root"
    group "root"
    mode "0600"
    notifies :run, resources(:execute => "preseed-mysql-server"), :immediately
  end
  
  execute "preseed-percona-server" do
    command "debconf-set-selections /var/cache/local/preseeding/percona-server.seed"
    action :nothing
  end

  template "/var/cache/local/preseeding/percona-server.seed" do
    source "percona-server.seed.erb"
    backup false
    owner "root"
    group "root"
    mode "0600"
    notifies :run, resources(:execute => "preseed-percona-server"), :immediately
  end
  
  template "/etc/mysql/debian.cnf" do
    source "debian.cnf.erb"
    backup false
    owner "root"
    group "root"
    mode "0600"
  end
end

if node[:mysql][:use_percona_xtradb]
  include_recipe "mysql::percona_server"
else
  package "mysql-server"
end

if node[:platform] == 'ubuntu' && node[:platform_version].to_f < 10.04
  remote_file "/tmp/mysql_init.patch" do
    source "mysql_init.patch"
  end

  execute "Fix MySQL init.d script to sleep longer - needed for instances with more RAM" do
    cwd "/etc/init.d"
    command "patch -p0 mysql < /tmp/mysql_init.patch"
    action :run
    only_if do
      File.read("/etc/init.d/mysql").match(/sleep 1/)
    end
  end
end

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
  notifies :restart, resources(:service => "apparmor"), :immediately
end

service "mysql" do
  service_name value_for_platform([ "centos", "redhat", "suse" ] => {"default" => "mysqld"}, "default" => "mysql")

  case node[:platform]
  when "ubuntu"
    if node[:platform_version].to_f >= 10.04
      provider Chef::Provider::Service::Upstart
    end
  end
  supports :status => true, :restart => true, :reload => true
  action :enable
end

service "mysql" do
  action :stop
  case node[:platform]
  when "ubuntu"
    if node[:platform_version].to_f >= 10.04
      provider Chef::Provider::Service::Upstart
    end
  end
end

if (node[:ec2] && ! FileTest.directory?(node[:mysql][:ec2_path]))
  Chef::Log.info("Setting up the MySQL bind-mount to EBS")

  execute "install-mysql" do
    command "mv #{node[:mysql][:datadir]} #{node[:mysql][:ec2_path]} && mkdir -p #{node[:mysql][:datadir]}"
    not_if do FileTest.directory?(node[:mysql][:ec2_path]) end
  end

  directory node[:mysql][:ec2_path] do
    owner "mysql"
    group "mysql"
  end
  
  mount node[:mysql][:datadir] do
    device node[:mysql][:ec2_path]
    fstype "none"
    options "bind,rw"
    action :mount
  end
  
  mount node[:mysql][:datadir] do
    device node[:mysql][:ec2_path]
    fstype "none"
    options "bind,rw"
    action :enable
  end
  
  execute "ensure MySQL data owned by MySQL user" do
    command "chown -R mysql:mysql #{node[:mysql][:datadir]}"
    action :run
  end
  
else
  Chef::Log.info("Skipping MySQL EBS setup")
end

template value_for_platform([ "centos", "redhat", "suse" ] => {"default" => "/etc/my.cnf"}, "default" => "/etc/mysql/my.cnf") do
  source "my.cnf.erb"
  backup false
  owner "root"
  group "root"
  mode "0644"
  #notifies :restart, resources(:service => "mysql"), :immediately
end

service "mysql" do
  case node[:platform]
  when "ubuntu"
    if node[:platform_version].to_f >= 10.04
      provider Chef::Provider::Service::Upstart
    end
  end
  
  action :start
end
