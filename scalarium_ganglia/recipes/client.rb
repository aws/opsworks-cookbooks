#package "ganglia client" do
#  package_name value_for_platform(
#  # TODO: Need to either add the EPEL repo, or build/import packages by hand:
#    ['centos','redhat','fedora','amazon'] => {'default' => 'ganglia-gmond'},
#    ['debian','ubuntu'] => {'default' => 'ganglia-monitor'}
#  )
#end

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

if platform?('centos','redhat','fedora','amazon')
  # this will be installed in ubuntu as dep to ganglia
  package 'ganglia-gmond-python'
end

execute 'stop gmond with non-updated configuration' do
  command value_for_platform(
    ['centos','redhat','fedora','amazon'] => {
      'default' => '/etc/init.d/gmond stop'
    },
    ['debian','ubuntu'] => {
      'default' => '/etc/init.d/ganglia-monitor stop'
    }
  )
end

['scripts','conf.d','python_modules'].each do |dir|
  directory "/etc/ganglia/#{dir}" do
    action :create
    owner 'root'
    group 'root'
    mode 0755
  end
end

include_recipe 'scalarium_ganglia::monitor-fd-and-sockets'
include_recipe 'scalarium_ganglia::monitor-disk'

case node[:scalarium][:instance][:roles]
when 'memcached'
  include_recipe 'scalarium_ganglia::monitor-memcached'
when 'db-master'
  include_recipe 'scalarium_ganglia::monitor-mysql'
when 'lb'
  include_recipe 'scalarium_ganglia::monitor-haproxy'
when 'php-app','monitoring-master'
  include_recipe 'scalarium_ganglia::monitor-apache'
when 'web'
  include_recipe 'scalarium_ganglia::monitor-nginx'
when 'rails-app'

  case node[:scalarium][:rails_stack][:name]
  when 'apache_passenger'
    include_recipe 'scalarium_ganglia::monitor-passenger'
    include_recipe 'scalarium_ganglia::monitor-apache'
  when 'nginx_unicorn'
    include_recipe 'scalarium_ganglia::monitor-nginx'
  end

end
