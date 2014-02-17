###
# Do not use this file to override the passenger_apache2 cookbook's default
# attributes.  Instead, please use the customize.rb attributes file,
# which will keep your adjustments separate from the AWS OpsWorks
# codebase and make it easier to upgrade.
#
# However, you should not edit customize.rb directly. Instead, create
# "passenger_apache2/attributes/customize.rb" in your cookbook repository and
# put the overrides in YOUR customize.rb file.
#
# Do NOT create an 'passenger_apache2/attributes/passenger.rb' in your cookbooks. Doing so
# would completely override this file and might cause upgrade issues.
#
# See also: http://docs.aws.amazon.com/opsworks/latest/userguide/customizing.html
###

require 'rubygems/version'

include_attribute 'opsworks_initial_setup::default'
include_attribute 'rails::rails'
include_attribute 'packages::packages'

case node[:opsworks][:ruby_version]
when /^1\.8/
  default[:passenger][:gems_path] = '/usr/local/lib/ruby/gems/1.8/gems'
when /^1\.9/
  default[:passenger][:gems_path] = '/usr/local/lib/ruby/gems/1.9.1/gems'
when /^2\.0/
  default[:passenger][:gems_path] = '/usr/local/lib/ruby/gems/2.0.0/gems'
when /^2\.1/
  default[:passenger][:gems_path] = '/usr/local/lib/ruby/gems/2.1.0/gems'
else
  Chef::Log.warn "Unsupported Ruby version '#{node[:opsworks][:ruby_version]}'. Unable to set passenger gems_path."
  default[:passenger][:gems_path] = '/'
end

default[:passenger][:version] = '4.0.33'
default[:passenger][:root_path] = "#{node[:passenger][:gems_path]}/passenger-#{passenger[:version]}"

if platform?('centos','redhat','fedora','amazon') and node[:packages][:dist_only]
  default[:passenger][:module_path] = "#{node['apache']['libexecdir']}/mod_passenger.so"
else

 if ::Gem::Version.new(node[:passenger][:version]) >= ::Gem::Version.new("4.0.7")
   default[:passenger][:module_path] = "#{passenger[:root_path]}/buildout/apache2/mod_passenger.so"
 elsif ::Gem::Version.new(node[:passenger][:version]) >= ::Gem::Version.new("3.9")
   default[:passenger][:module_path] = "#{passenger[:root_path]}/libout/apache2/mod_passenger.so"
 else
   default[:passenger][:module_path] = "#{passenger[:root_path]}/ext/apache2/mod_passenger.so"
 end

end

default[:passenger][:ruby_bin] = '/usr/local/bin/ruby'
default[:passenger][:ruby_wrapper_bin] = '/usr/local/bin/ruby_gc_wrapper.sh'
default[:passenger][:gem_bin] = '/usr/local/bin/gem'
default[:passenger][:stat_throttle_rate] = 5
default[:passenger][:rails_framework_spawner_idle_time] = 0
default[:passenger][:rails_app_spawner_idle_time] = 0
default[:passenger][:pool_idle_time] = 14400 # 4 hours
default[:passenger][:max_instances_per_app] = 0
default[:passenger][:max_requests] = 0
default[:passenger][:high_performance_mode] = 'off'
default[:passenger][:rails_spawn_method] = 'smart-lv2'
default[:passenger][:max_pool_size] = 8 # usually will be set by OpsWorks directy. Override if you need a custom size

include_attribute "passenger_apache2::customize"
