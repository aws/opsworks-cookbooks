default[:ganglia][:datadir] = "/vol/ganglia"
default[:ganglia][:conf_dir] = "#{node[:ganglia][:datadir]}/conf"
default[:ganglia][:events_dir] = "#{node[:ganglia][:datadir]}/conf/events.json.d/"
default[:ganglia][:original_datadir] = "/var/lib/ganglia"
default[:ganglia][:tcp_client_port] = 8649
default[:ganglia][:udp_client_port] = 8666
default[:ganglia][:user] = 'ganglia'
default[:ganglia][:rrds_user] = 'nobody'

default[:ganglia][:web][:url] = '/ganglia'
default[:ganglia][:web][:user] = 'scalarium'

# gweb2 Makefile config
default[:ganglia][:web][:destdir] = '/usr/share/ganglia-webfrontend'
default[:ganglia][:web][:apache_user] = 'www-data'
default[:ganglia][:web][:svn] = 'no'

pw = String.new

while pw.length < 20
  pw << OpenSSL::Random.random_bytes(1).gsub(/\W/, '')
end

default[:ganglia][:web][:password] = pw


default[:ganglia][:nginx][:status_url] = '/nginx_status'
