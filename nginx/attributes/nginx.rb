###
# Do not use this file to override the nginx cookbook's default
# attributes.  Instead, please use the customize.rb attributes file,
# which will keep your adjustments separate from the AWS OpsWorks
# codebase and make it easier to upgrade.
#
# However, you should not edit customize.rb directly. Instead, create
# "nginx/attributes/customize.rb" in your cookbook repository and
# put the overrides in YOUR customize.rb file.
#
# Do NOT create an 'nginx/attributes/nginx.rb' in your cookbooks. Doing so
# would completely override this file and might cause upgrade issues.
#
# See also: http://docs.aws.amazon.com/opsworks/latest/userguide/customizing.html
###

case node[:platform]
when 'debian','ubuntu'
  default[:nginx][:dir]     = '/etc/nginx'
  default[:nginx][:log_dir] = '/var/log/nginx'
  default[:nginx][:user]    = 'www-data'
  default[:nginx][:binary]  = '/usr/sbin/nginx'
when 'centos','redhat','fedora','amazon'
  default[:nginx][:dir]     = '/etc/nginx'
  default[:nginx][:log_dir] = '/var/log/nginx'
  default[:nginx][:user]    = 'nginx'
  default[:nginx][:binary]  = '/usr/sbin/nginx'
else
  Chef::Log.error "Cannot configure nginx, platform unknown"
end

default[:nginx][:log_format] = {}

# increase if you accept large uploads
default[:nginx][:client_max_body_size] = '4m'

default[:nginx][:gzip] = 'on'
default[:nginx][:gzip_static] = 'on'
default[:nginx][:gzip_vary] = 'on'
default[:nginx][:gzip_disable] = 'MSIE [1-6].(?!.*SV1)'
default[:nginx][:gzip_http_version] = '1.0'
default[:nginx][:gzip_comp_level] = '2'
default[:nginx][:gzip_proxied] = 'any'
default[:nginx][:gzip_types] = ['application/x-javascript',
                                'application/xhtml+xml',
                                'application/xml',
                                'application/xml+rss',
                                'text/css',
                                'text/javascript',
                                'text/plain',
                                'text/xml']
# NGinx will compress 'text/html' by default

default[:nginx][:keepalive] = 'on'
default[:nginx][:keepalive_timeout] = 65

default[:nginx][:worker_processes] = 10
default[:nginx][:worker_connections] = 1024
default[:nginx][:server_names_hash_bucket_size] = 64

default[:nginx][:proxy_read_timeout] = 60
default[:nginx][:proxy_send_timeout] = 60

include_attribute "nginx::customize"
