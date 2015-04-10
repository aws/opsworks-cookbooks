default[:nginx][:dir]     = "/etc/nginx"
default[:nginx][:log_dir] = "/var/log/nginx"
default[:nginx][:binary]  = "/usr/sbin/nginx"
default[:nginx][:root]    = "/var/www/nginx"

default[:nginx][:user]    = case node[:platform]
  when 'debian', 'ubuntu' then 'www-data'
  when 'redhat', 'centos', 'scientific', 'amazon', 'oracle', 'fedora' then 'nginx'
  else 'nginx'
end

default[:nginx][:keepalive]          = "on"
default[:nginx][:keepalive_timeout]  = 65
default[:nginx][:worker_processes]   = node[:cpu][:total] rescue 1
default[:nginx][:worker_connections] = 2048
