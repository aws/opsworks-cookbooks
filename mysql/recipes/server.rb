require 'resolv'

include_recipe "mysql::client"

include_recipe "mysql::prepare"

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

include_recipe "mysql::apparmor"

include_recipe 'mysql::service'

service "mysql" do
  action :enable
end

service "mysql" do
  action :stop
end

include_recipe "mysql::ebs"

include_recipe "mysql::config"

service "mysql" do
  action :start
end

