require 'resolv'

include_recipe 'mysql::client'
include_recipe 'mysql::prepare'

# for backwards compatiblity default the package name to mysql
mysql_name = node[:mysql][:name] || "mysql"

package "#{mysql_name}-server"

if platform?('ubuntu') && node[:platform_version].to_f < 10.04
  remote_file '/tmp/mysql_init.patch' do
    source 'mysql_init.patch'
  end

  execute 'Fix MySQL init.d script to sleep longer - needed for instances with more RAM' do
    cwd '/etc/init.d'
    command 'patch -p0 mysql < /tmp/mysql_init.patch'
    action :run
    only_if do
      File.read('/etc/init.d/mysql').match(/sleep 1/)
    end
  end
end

if platform?('debian','ubuntu')
  include_recipe 'mysql::apparmor'
end

include_recipe 'mysql::service'

service "mysql" do
  action :enable
end

service "mysql" do
  action :stop
end


include_recipe 'mysql::ebs' if infrastructure_class?('ec2')
include_recipe 'mysql::config'

service "mysql" do
  action :start
end

if platform?('centos','redhat','fedora','amazon')
  execute 'assign root password' do
    command "#{node[:mysql][:mysqladmin_bin]} -u root password \"#{node[:mysql][:server_root_password]}\""
    action :run
    only_if "#{node[:mysql][:mysql_bin]} -u root -e 'show databases;'"
  end
end
