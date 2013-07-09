nginx Mash.new unless attribute?('nginx')

case node[:platform]
when 'debian','ubuntu'
  nginx[:dir]     = '/etc/nginx'
  nginx[:log_dir] = '/var/log/nginx'
  nginx[:user]    = 'www-data'
  nginx[:binary]  = '/usr/sbin/nginx'
when 'centos','redhat','fedora','amazon'
  nginx[:dir]     = '/etc/nginx'
  nginx[:log_dir] = '/var/log/nginx'
  nginx[:user]    = 'nginx'
  nginx[:binary]  = '/usr/sbin/nginx'
else
  Chef::Log.error "Cannot configure nginx, platform unknown"
end

# increase if you accept large uploads
default[:nginx][:client_max_body_size] = '4m'

default[:nginx][:gzip] = 'on'
default[:nginx][:gzip_static] = 'on'
default[:nginx][:gzip_vary] = 'on'
default[:nginx][:gzip_disable] = 'MSIE [1-6].(?!.*SV1)'
default[:nginx][:gzip_http_version] = '1.0'
default[:nginx][:gzip_comp_level] = '2'
default[:nginx][:gzip_proxied] = 'any'
default[:nginx][:gzip_types] = ['text/plain',
                                'text/html',
                                'text/css',
                                'application/x-javascript',
                                'text/xml',
                                'application/xml',
                                'application/xml+rss',
                                'text/javascript']

default[:nginx][:keepalive] = 'on'
default[:nginx][:keepalive_timeout] = 65

default[:nginx][:worker_processes] = 10
default[:nginx][:worker_connections] = 1024
default[:nginx][:server_names_hash_bucket_size] = 64
