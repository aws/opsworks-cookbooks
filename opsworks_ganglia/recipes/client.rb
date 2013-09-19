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
  package node[:ganglia][:monitor_plugins_package_name]
end

execute 'stop gmond with non-updated configuration' do
  command value_for_platform_family(
    "rhel" => '/etc/init.d/gmond stop',
    "debian" => '/etc/init.d/ganglia-monitor stop'
  )
end

# old broken installations have this empty directory
# new working ones have a symlink
directory "/etc/ganglia/python_modules" do
  action :delete
  not_if { ::File.symlink?("/etc/ganglia/python_modules")}
end

link "/etc/ganglia/python_modules" do
  to value_for_platform_family(
    "debian" => "/usr/lib/ganglia/python_modules",
    "rhel" => "/usr/lib#{RUBY_PLATFORM[/64/]}/ganglia/python_modules"
  )
end

execute "Normalize ganglia plugin permissions" do
  command "chmod 644 /etc/ganglia/python_modules/*"
end

['scripts','conf.d'].each do |dir|
  directory "/etc/ganglia/#{dir}" do
    action :create
    owner "root"
    group "root"
    mode "0755"
  end
end

include_recipe 'opsworks_ganglia::monitor-fd-and-sockets'
include_recipe 'opsworks_ganglia::monitor-disk'

node[:opsworks][:instance][:layers].each do |layer|
  case layer
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
end
