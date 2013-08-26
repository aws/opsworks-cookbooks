require 'securerandom'

include_attribute 'opsworks_initial_setup::default'
include_attribute 'apache2::apache'

default[:ganglia][:datadir] = '/vol/ganglia'
default[:ganglia][:conf_dir] = "#{node[:ganglia][:datadir]}/conf"
default[:ganglia][:events_dir] = "#{node[:ganglia][:datadir]}/conf/events.json.d/"
default[:ganglia][:original_datadir] = '/var/lib/ganglia'
default[:ganglia][:autofs_options] = "-fstype=none,bind,rw"
default[:ganglia][:autofs_entry] = "#{node[:ganglia][:original_datadir]} #{node[:ganglia][:autofs_options]} :#{node[:ganglia][:datadir]}"
default[:ganglia][:tcp_client_port] = 8649
default[:ganglia][:udp_client_port] = 8666
default[:ganglia][:user] = 'ganglia'
default[:ganglia][:rrds_user] = 'nobody'

case node[:platform_family]
when "debian"
  default[:ganglia][:gmetad_package_name] = "gmetad"
  default[:ganglia][:web_frontend_package_name] = "ganglia-webfrontend"
  default[:ganglia][:libganglia_package_name] = "libganglia1"
  default[:ganglia][:monitor_package_name] = "ganglia-monitor"
  default[:ganglia][:monitor_plugins_package_name] = "ganglia-monitor-python"

  default[:ganglia][:custom_package_version] = '3.3.8-1'
  default[:ganglia][:package_arch] = RUBY_PLATFORM.match(/64/) ? 'amd64' : 'i386'
  default[:ganglia][:package_base_url] = "#{node[:opsworks_commons][:assets_url]}/packages/#{node[:platform]}/#{node[:platform_version]}"

  default[:ganglia][:gmetad_package] = "#{node[:ganglia][:gmetad_package_name]}_#{node[:ganglia][:custom_package_version]}_#{node[:ganglia][:package_arch]}.deb"
  default[:ganglia][:web_frontend_package] = "#{node[:ganglia][:web_frontend_package_name]}_#{node[:ganglia][:custom_package_version]}_all.deb"
  default[:ganglia][:monitor_plugins_package] = "#{node[:ganglia][:monitor_plugins_package_name]}_#{node[:ganglia][:custom_package_version]}_all.deb"
 
  default[:ganglia][:gmetad_package_url] = "#{node[:ganglia][:package_base_url]}/#{node[:ganglia][:gmetad_package]}"
  default[:ganglia][:web_frontend_package_url] = "#{node[:ganglia][:package_base_url]}/#{node[:ganglia][:web_frontend_package]}"
  default[:ganglia][:monitor_plugins_package_url] = "#{node[:ganglia][:package_base_url]}/#{node[:ganglia][:monitor_plugins_package]}"

  default[:ganglia][:web_frontend_dependencies] = ["apache2","libapache2-mod-php5","rrdtool","libgd2-noxpm","libgd2-xpm","php5-gd"]
when "rhel"
  default[:ganglia][:gmetad_package_name] = "ganglia-gmetad"
  default[:ganglia][:monitor_package_name] = "ganglia-gmond"
  default[:ganglia][:monitor_plugins_package_name] = "ganglia-gmond-python"
  default[:ganglia][:web_frontend_package_name] = "ganglia-web"
end

default[:ganglia][:nginx][:status_url] = '/nginx_status'
default[:ganglia][:web][:svn] = 'no'
default[:ganglia][:web][:url] = '/ganglia'
default[:ganglia][:web][:welcome_page] = 'ganglia_welcome.html'

default[:ganglia][:web][:user] = (node['ganglia']['web']['user'] rescue nil) || 'opsworks'

default[:ganglia][:web][:destdir] = case node[:platform_family]
                                    when "rhel"
                                      "/usr/share/ganglia"
                                    when "debian"
                                      "/usr/share/ganglia-webfrontend"
                                    end 
