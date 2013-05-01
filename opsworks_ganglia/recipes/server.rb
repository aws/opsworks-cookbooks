include_recipe 'opsworks_ganglia::client'

case node[:platform]
when 'debian','ubuntu'
  remote_file '/tmp/gmetad.deb' do
    source "#{node[:opsworks_commons][:assets_url]}/packages/#{node[:platform]}/#{node[:platform_version]}/gmetad_3.3.8-1_#{RUBY_PLATFORM.match(/64/) ? 'amd64' : 'i386'}.deb"
    not_if { `dpkg-query --show gmetad | cut -f 2`.chomp.eql?('3.3.8-1') }
  end
  package 'librrd4'
  execute 'install and cleanup' do
    command 'dpkg -i /tmp/gmetad.deb && rm /tmp/gmetad.deb'
    only_if { ::File.exists?('/tmp/gmetad.deb') }
  end

when 'centos','redhat','fedora','amazon'
  package 'ganglia-gmetad'
end

# install old ganglia frontend to bring in all dependencies
package 'ganglia-webfrontend' do
  package_name value_for_platform(
    ['centos','redhat','fedora','amazon'] => {'default' => 'ganglia-web'},
    ['debian','ubuntu'] => {'default' => 'ganglia-webfrontend'}
  )
end

# we install a newer version of ganglia on ubuntu and just need the dependencies
package 'ganglia-webfrontend' do
  package_name value_for_platform(
    ['debian','ubuntu'] => {'default' => 'ganglia-webfrontend'}
  )
  action :remove
end

include_recipe 'opsworks_ganglia::service-gmetad'

service 'gmetad' do
  action :stop
end

include_recipe 'opsworks_ganglia::bind-mount-data'

template '/etc/ganglia/gmetad.conf' do
  source 'gmetad.conf.erb'
  variables :stack_name => node[:opsworks][:stack][:name]
  mode 0644
end

include_recipe 'opsworks_ganglia::custom-install'
include_recipe 'apache2::service'

service 'gmetad' do
  action [ :enable, :start ]
end

service 'apache2' do
  action :restart
end
