include_attribute 'opsworks_commons::default'

default[:ganglia][:custom_package_version] = '3.3.8-1'

default[:ganglia][:datadir] = '/vol/ganglia'
default[:ganglia][:conf_dir] = "#{node[:ganglia][:datadir]}/conf"
default[:ganglia][:events_dir] = "#{node[:ganglia][:datadir]}/conf/events.json.d/"
default[:ganglia][:original_datadir] = '/var/lib/ganglia'
default[:ganglia][:opsworks_autofs_map_file] = '/etc/auto.opsworks'
default[:ganglia][:tcp_client_port] = 8649
default[:ganglia][:udp_client_port] = 8666
default[:ganglia][:user] = 'ganglia'
default[:ganglia][:rrds_user] = 'nobody'

case node[:platform]
when 'debian','ubuntu'
  default[:ganglia][:web][:apache_user]  = 'www-data'
  default[:ganglia][:web][:apache_group] = 'www-data'
when 'centos','redhat','fedora','amazon'
  default[:ganglia][:web][:apache_user]  = 'apache'
  default[:ganglia][:web][:apache_group] = 'apache'
end

default[:ganglia][:web][:svn] = 'no'
default[:ganglia][:web][:url] = '/ganglia'
default[:ganglia][:web][:user] = 'opsworks'
# gweb2 Makefile config
default[:ganglia][:web][:destdir] = '/usr/share/ganglia-webfrontend'

pw = String.new
while pw.length < 20
  pw << OpenSSL::Random.random_bytes(1).gsub(/\W/, '')
end

default[:ganglia][:web][:password] = pw

default[:ganglia][:nginx][:status_url] = '/nginx_status'
