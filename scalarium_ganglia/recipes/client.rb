package "ganglia-monitor"

execute "stop gmond with non-updated configuration" do
  command "/etc/init.d/ganglia-monitor stop"
end

directory "/etc/ganglia/scripts" do
  action :create
  owner "root"
  group "root"
  mode '0755'
end

directory "/etc/ganglia/conf.d" do
  action :create
  owner "root"
  group "root"
  mode '0755'
end

directory "/etc/ganglia/python_modules" do
  action :create
  owner "root"
  group "root"
  mode '0755'
end

include_recipe "scalarium_ganglia::monitor-fd-and-sockets"
include_recipe "scalarium_ganglia::monitor-disk"
include_recipe "scalarium_ganglia::monitor-memcached" if node[:scalarium][:instance][:roles].include?('memcached')
include_recipe "scalarium_ganglia::monitor-mysql" if node[:scalarium][:instance][:roles].include?('db-master')
include_recipe "scalarium_ganglia::monitor-haproxy" if node[:scalarium][:instance][:roles].include?('lb')
include_recipe "scalarium_ganglia::monitor-passenger" if node[:scalarium][:instance][:roles].include?('rails-app')
include_recipe "scalarium_ganglia::monitor-apache" if node[:scalarium][:instance][:roles].any?{|role| ['rails-app', 'php-app', 'monitor-master'].include?(role) }
include_recipe "scalarium_ganglia::monitor-nginx" if node[:scalarium][:instance][:roles].include?('web')
