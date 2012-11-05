package "ganglia client" do
  package_name value_for_platform(
  # TODO: Need to either add the EPEL repo, or build/import packages by hand:
    ['centos','redhat','fedora','amazon'] => {'default' => 'ganglia-gmond'},
    ['debian','ubuntu'] => {'default' => 'ganglia-monitor'}
  )
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
