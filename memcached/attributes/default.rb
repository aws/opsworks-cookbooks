###
# Do not use this file to override the memcached cookbook's default
# attributes.  Instead, please use the customize.rb attributes file,
# which will keep your adjustments separate from the AWS OpsWorks
# codebase and make it easier to upgrade.
#
# However, you should not edit customize.rb directly. Instead, create
# "memcached/attributes/customize.rb" in your cookbook repository and
# put the overrides in YOUR customize.rb file.
#
# Do NOT create an 'memcached/attributes/default.rb' in your cookbooks. Doing so
# would completely override this file and might cause upgrade issues.
#
# See also: http://docs.aws.amazon.com/opsworks/latest/userguide/customizing.html
###

default[:memcached][:memory] = 512
default[:memcached][:port] = 11211
default[:memcached][:user] = "nobody"
default[:memcached][:max_connections] = "4096"

case node[:platform]
when 'redhat', 'centos', 'fedora', 'amazon'
  default[:memcached][:pid_file] = '/var/run/memcached/memcached.pid'
when 'debian', 'ubuntu'
  default[:memcached][:pid_file] = '/var/run/memcached.pid'
else
  raise 'Bailing out, unknown platform.'
end

default[:memcached][:start_command] = "/etc/init.d/memcached start"
default[:memcached][:stop_command] = "/etc/init.d/memcached stop"
default[:memcached][:testing][:gem_version] = '1.6.1'

include_attribute "memcached::customize"
