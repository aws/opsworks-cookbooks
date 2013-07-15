default[:memcached][:memory] = 512
default[:memcached][:port] = 11211
default[:memcached][:user] = "nobody"
default[:memcached][:max_connections] = "4096"
default[:memcached][:pid_file] = "/var/run/memcached.pid"
default[:memcached][:start_command] = "/etc/init.d/memcached start"
default[:memcached][:stop_command] = "/etc/init.d/memcached stop"
default[:memcached][:testing][:gem_version] = '1.6.1'
