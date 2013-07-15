case node[:platform_family]
when "debian"
  package 'libapr1'
  package 'libconfuse0'

  ['libganglia1','ganglia-monitor'].each do |package_name|
    remote_file "/tmp/#{package_name}.deb" do
      source "#{node[:ganglia][:package_base_url]}/#{package_name}_#{node[:ganglia][:custom_package_version]}_#{node[:ganglia][:package_arch]}.deb"
      not_if do
        `dpkg-query --show #{package_name} | cut -f 2`.chomp.eql?(node[:ganglia][:package_arch])
      end
    end

    execute "install #{package_name}" do
      command "dpkg -i /tmp/#{package_name}.deb && rm /tmp/#{package_name}.deb"
      only_if { ::File.exists?("/tmp/#{package_name}.deb") }
    end
  end

  remote_file '/tmp/ganglia-monitor-python.deb' do
    source node[:ganglia][:monitor_plugins_package_url]
    not_if { ::File.exists?('/tmp/ganglia-monitor-python.deb') }
  end
  execute 'install ganglia-monitor-python' do
    command 'dpkg -i /tmp/ganglia-monitor-python.deb && rm /tmp/ganglia-monitor-python.deb'
    only_if { ::File.exists?('/tmp/ganglia-monitor-python.deb') }
  end

when "rhel"
  package node[:ganglia][:monitor_package_name]
end

execute 'stop gmond with non-updated configuration' do
  command value_for_platform_family(
    "rhel" => '/etc/init.d/gmond stop',
    "debian" => '/etc/init.d/ganglia-monitor stop'
  )
end

['scripts','conf.d','python_modules'].each do |dir|
  directory "/etc/ganglia/#{dir}" do
    action :create
    owner "root"
    group "root"
    mode "0755"
  end
end

include_recipe 'opsworks_ganglia::monitor-fd-and-sockets'
include_recipe 'opsworks_ganglia::monitor-disk'

case node[:opsworks][:instance][:layers]
when 'memcached'
  include_recipe 'opsworks_ganglia::monitor-memcached'
when 'db-master'
  include_recipe 'opsworks_ganglia::monitor-mysql'
when 'lb'
  include_recipe 'opsworks_ganglia::monitor-haproxy'
when 'php-app','monitoring-master'
  include_recipe 'opsworks_ganglia::monitor-apache'
when 'web'
  include_recipe 'opsworks_ganglia::monitor-nginx'
when 'rails-app'

  case node[:opsworks][:rails_stack][:name]
  when 'apache_passenger'
    include_recipe 'opsworks_ganglia::monitor-passenger'
    include_recipe 'opsworks_ganglia::monitor-apache'
  when 'nginx_unicorn'
    include_recipe 'opsworks_ganglia::monitor-nginx'
  end

end
