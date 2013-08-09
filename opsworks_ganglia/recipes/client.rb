case node[:platform]
when 'debian','ubuntu'
  package 'libapr1'
  package 'libconfuse0'

  ['libganglia1','ganglia-monitor'].each do |package_name|
    remote_file "/tmp/#{package_name}.deb" do
      source "#{node[:opsworks_commons][:assets_url]}/packages/#{node[:platform]}/#{node[:platform_version]}/#{package_name}_#{node[:ganglia][:custom_package_version]}_#{RUBY_PLATFORM.match(/64/) ? 'amd64' : 'i386'}.deb"
      not_if { `dpkg-query --show #{package_name} | cut -f 2`.chomp.eql?('3.3.8-1') }
    end
    execute "install #{package_name}" do
      command "dpkg -i /tmp/#{package_name}.deb && rm /tmp/#{package_name}.deb"
      only_if { ::File.exists?("/tmp/#{package_name}.deb") }
    end
  end

  remote_file '/tmp/ganglia-monitor-python.deb' do
    source "#{node[:opsworks_commons][:assets_url]}/packages/#{node[:platform]}/#{node[:platform_version]}/ganglia-monitor-python_3.3.8-1_all.deb"
    not_if { ::File.exists?('/tmp/ganglia-monitor-python.deb') }
  end
  execute '' do
    command 'dpkg -i /tmp/ganglia-monitor-python.deb && rm /tmp/ganglia-monitor-python.deb'
    only_if { ::File.exists?('/tmp/ganglia-monitor-python.deb') }
  end

when 'centos','redhat','fedora','amazon'
  package 'ganglia-gmond'
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
