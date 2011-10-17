default[:ganglia][:datadir] = "/vol/ganglia"
default[:ganglia][:origina_datadir] = "/var/lib/ganglia"
default[:ganglia][:tcp_client_port] = 8649
default[:ganglia][:udp_client_port] = 8666
default[:ganglia][:user] = 'ganglia'
default[:ganglia][:rrds_user] = 'nobody'

default[:ganglia][:web][:url] = '/ganglia'
default[:ganglia][:web][:user] = 'scalarium'

pw = String.new

while pw.length < 20
  pw << OpenSSL::Random.random_bytes(1).gsub(/\W/, '')
end

default[:ganglia][:web][:password] = pw


default[:ganglia][:nginx][:status_url] = '/nginx_status'

# gweb2 config
default[:ganglia][:gweb2][:url] = '/ganglia2'
default[:ganglia][:gweb2][:destdir] = '/var/www/ganglia2'
default[:ganglia][:gweb2][:apache_user] = 'www-data'
default[:ganglia][:gweb2][:svn] = 'no'

