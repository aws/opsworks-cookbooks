if node[:platform] == 'ubuntu' && ['12.04', '11.10', '11.04'].include?(node[:platform_version].to_s)
  remote_file '/tmp/ganglia-monitor.deb' do
    source "http://peritor-assets.s3.amazonaws.com/#{node[:platform]}/#{node[:platform_version]}/ganglia-monitor_3.2.0-7_#{RUBY_PLATFORM.match(/64/) ? 'amd64' : 'i386'}.deb"
    not_if { ::File.exists?('/tmp/ganglia-monitor.deb') }
  end
  remote_file '/tmp/libganglia1.deb' do
    source "http://peritor-assets.s3.amazonaws.com/#{node[:platform]}/#{node[:platform_version]}/libganglia1_3.2.0-7_#{RUBY_PLATFORM.match(/64/) ? 'amd64' : 'i386'}.deb"
    not_if { ::File.exists?('/tmp/libganglia1.deb') }
  end

  execute 'apt-get -q -y install libapr1 libconfuse0'
  if node[:platform] == 'ubuntu' && node[:platform_version].to_s == '11.04'
    execute 'apt-get -q -y install libpython2.7'
  end
  execute 'dpkg -i /tmp/libganglia1.deb'
  execute 'dpkg -i /tmp/ganglia-monitor.deb'
else
  package "ganglia-monitor"
end

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
include_recipe "scalarium_ganglia::monitor-apache" if node[:scalarium][:instance][:roles].any?{|role| ['php-app', 'monitoring-master'].include?(role) }
if node[:scalarium][:instance][:roles].include?('rails-app')
  include_recipe "scalarium_ganglia::monitor-passenger" if node[:scalarium][:rails_stack][:name] == 'apache_passenger'
  include_recipe "scalarium_ganglia::monitor-apache" if node[:scalarium][:rails_stack][:name] == 'apache_passenger'
  include_recipe "scalarium_ganglia::monitor-nginx" if node[:scalarium][:rails_stack][:name] == 'nginx_unicorn'
end
include_recipe "scalarium_ganglia::monitor-nginx" if node[:scalarium][:instance][:roles].include?('web')
