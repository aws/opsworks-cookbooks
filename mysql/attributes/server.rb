require 'openssl'

root_pw = String.new
while root_pw.length < 20
  root_pw << OpenSSL::Random.random_bytes(1).gsub(/\W/, '')
end

default[:mysql][:server_root_password] = root_pw

debian_pw = String.new
while debian_pw.length < 20
  debian_pw << OpenSSL::Random.random_bytes(1).gsub(/\W/, '')
end

default[:mysql][:debian_sys_maintainer_user]     = 'debian-sys-maint'
default[:mysql][:debian_sys_maintainer_password] = debian_pw

default[:mysql][:bind_address]         = '0.0.0.0'
default[:mysql][:port]                 = 3306

case node[:platform]
when 'centos','redhat','fedora','amazon'
  default[:mysql][:datadir]              = '/var/lib/mysql'
  default[:mysql][:logdir]               = '/var/log/mysql'
  default[:mysql][:basedir]              = '/usr'
  default[:mysql][:user]                 = 'mysql'
  default[:mysql][:group]                = 'mysql'
  default[:mysql][:root_group]           = 'root'
  default[:mysql][:mysqladmin_bin]       = '/usr/bin/mysqladmin'
  default[:mysql][:mysql_bin]            = '/usr/bin/mysql'

  set[:mysql][:conf_dir]                 = '/etc'
  set[:mysql][:confd_dir]                = '/etc/mysql/conf.d'
  set[:mysql][:socket]                   = '/var/lib/mysql/mysql.sock'
  set[:mysql][:pid_file]                 = '/var/run/mysqld/mysqld.pid'
  set[:mysql][:grants_path]              = '/etc/mysql_grants.sql'
when 'debian','ubuntu'
  default[:mysql][:datadir]              = '/var/lib/mysql'
  default[:mysql][:logdir]               = '/var/log/mysql'
  default[:mysql][:basedir]              = '/usr'
  default[:mysql][:user]                 = 'mysql'
  default[:mysql][:group]                = 'mysql'
  default[:mysql][:root_group]           = 'root'
  default[:mysql][:mysqladmin_bin]       = '/usr/bin/mysqladmin'
  default[:mysql][:mysql_bin]            = '/usr/bin/mysql'

  set[:mysql][:conf_dir]                 = '/etc/mysql'
  set[:mysql][:confd_dir]                = '/etc/mysql/conf.d'
  set[:mysql][:socket]                   = '/var/run/mysqld/mysqld.sock'
  set[:mysql][:pid_file]                 = '/var/run/mysqld/mysqld.pid'
  set[:mysql][:grants_path]              = '/etc/mysql/grants.sql'
end

default[:mysql][:ec2_path]                 = '/mnt/mysql'
default[:mysql][:opsworks_autofs_map_file] = '/etc/auto.opsworks'
default[:mysql][:autofs_options] = "-fstype=none,bind,rw"
default[:mysql][:autofs_entry] = "#{node[:mysql][:datadir]} #{node[:mysql][:autofs_options]} :#{node[:mysql][:ec2_path]}"

# Tunables

# InnoDB
default[:mysql][:tunable][:innodb_buffer_pool_size]         = '1200M'
default[:mysql][:tunable][:innodb_additional_mem_pool_size] = '20M'
default[:mysql][:tunable][:innodb_flush_log_at_trx_commit]  = '2'
default[:mysql][:tunable][:innodb_lock_wait_timeout]        = '50'

# query cache
default[:mysql][:tunable][:query_cache_type]    = '1'
default[:mysql][:tunable][:query_cache_size]    = '128M'
default[:mysql][:tunable][:query_cache_limit]   = '2M'

# MyISAM & general
default[:mysql][:tunable][:max_allowed_packet]  = '32M'
default[:mysql][:tunable][:thread_stack]        = '192K'
default[:mysql][:tunable][:thread_cache_size]   = '8'
default[:mysql][:tunable][:key_buffer]          = '250M'
default[:mysql][:tunable][:max_connections]     = '2048'
default[:mysql][:tunable][:wait_timeout]        = '180'
default[:mysql][:tunable][:net_read_timeout]    = '30'
default[:mysql][:tunable][:net_write_timeout]   = '30'
default[:mysql][:tunable][:back_log]            = '128'
default[:mysql][:tunable][:table_cache]         = '2048'
default[:mysql][:tunable][:max_heap_table_size] = '32M'

default[:mysql][:tunable][:log_slow_queries]    = File.join(node[:mysql][:logdir], 'mysql-slow.log')
default[:mysql][:tunable][:long_query_time]     = 1

default[:mysql][:clients] = []
