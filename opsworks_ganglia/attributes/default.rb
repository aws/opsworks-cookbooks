###
# Do not use this file to override the opsworks_ganglia cookbook's default
# attributes.  Instead, please use the customize.rb attributes file,
# which will keep your adjustments separate from the AWS OpsWorks
# codebase and make it easier to upgrade.
#
# However, you should not edit customize.rb directly. Instead, create
# "opsworks_ganglia/attributes/customize.rb" in your cookbook repository and
# put the overrides in YOUR customize.rb file.
#
# Do NOT create an 'opsworks_ganglia/attributes/default.rb' in your cookbooks. Doing so
# would completely override this file and might cause upgrade issues.
#
# See also: http://docs.aws.amazon.com/opsworks/latest/userguide/customizing.html
###

require 'securerandom'

include_attribute 'opsworks_initial_setup::default'
include_attribute 'apache2::apache'

default[:ganglia][:datadir] = '/vol/ganglia'
default[:ganglia][:original_datadir] = '/var/lib/ganglia'
default[:ganglia][:conf_dir] = "#{node[:ganglia][:original_datadir]}/conf"
default[:ganglia][:events_dir] = "#{node[:ganglia][:original_datadir]}/conf/events.json.d/"
default[:ganglia][:tcp_client_port] = 8649
default[:ganglia][:udp_client_port] = 8666
default[:ganglia][:user] = 'ganglia'
default[:ganglia][:rrds_user] = 'nobody'

if infrastructure_class?('ec2')
  default[:ganglia][:autofs_options] = "-fstype=none,bind,rw"
  default[:ganglia][:autofs_entry] = "#{node[:ganglia][:original_datadir]} #{node[:ganglia][:autofs_options]} :#{node[:ganglia][:datadir]}"
end

case node[:platform_family]
when "debian"
  default[:ganglia][:custom_package_version] = '3.3.8'

  default[:ganglia][:libganglia_package_name] = "libganglia1"
  default[:ganglia][:monitor_package_name] = "ganglia-monitor"
  default[:ganglia][:monitor_plugins_package_name] = "ganglia-monitor-python"

  default[:ganglia][:gmetad_package_name] = "gmetad"
  default[:ganglia][:web_frontend_package_name] = "ganglia-webfrontend"

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

include_attribute "opsworks_ganglia::customize"
