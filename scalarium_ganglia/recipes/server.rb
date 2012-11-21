include_recipe "scalarium_ganglia::client"

if node[:platform] == 'ubuntu' && ['12.04', '11.10', '11.04'].include?(node[:platform_version].to_s)
  remote_file '/tmp/gmetad.deb' do
    source "http://peritor-assets.s3.amazonaws.com/#{node[:platform]}/#{node[:platform_version]}/gmetad_3.2.0-7_#{RUBY_PLATFORM.match(/64/) ? 'amd64' : 'i386'}.deb"
    not_if { ::File.exists?('/tmp/gmetad.deb') }
  end

  execute 'apt-get -q -y install librrd4'
  execute 'dpkg -i /tmp/gmetad.deb'
else
  package 'gmetad'
end

# install old ganglia frontend to bring in all dependencies
package "ganglia-webfrontend"
package "ganglia-webfrontend" do
  action :remove
end

include_recipe 'scalarium_ganglia::service-gmetad'

service "gmetad" do
  action :stop
end

include_recipe 'scalarium_ganglia::bind-mount-data'

template "/etc/ganglia/gmetad.conf" do
  mode '644'
  source "gmetad.conf.erb"
  variables :cluster_name => node[:scalarium][:cluster][:name]
end

include_recipe 'scalarium_ganglia::custom-install'
include_recipe 'apache2::service'

service "gmetad" do
  action [ :enable, :start ]
end

service "apache2" do
  action :restart
end
