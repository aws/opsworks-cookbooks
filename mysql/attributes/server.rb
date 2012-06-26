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
default[:mysql][:datadir]              = "/var/lib/mysql"

if attribute?(:ec2)
  default[:mysql][:ec2_path]    = "/mnt/mysql"
end

# Tunables

# InnoDB
default[:mysql][:tunable][:innodb_buffer_pool_size]         = "1200M"
default[:mysql][:tunable][:innodb_additional_mem_pool_size] = "20M"
default[:mysql][:tunable][:innodb_flush_log_at_trx_commit]  = "2"
default[:mysql][:tunable][:innodb_lock_wait_timeout]        = "50"

# query cache
default[:mysql][:tunable][:query_cache_type]    = "1"
default[:mysql][:tunable][:query_cache_size]    = "128M"
default[:mysql][:tunable][:query_cache_limit]   = "2M"

# MyISAM & general
default[:mysql][:tunable][:max_allowed_packet]  = "32M"
default[:mysql][:tunable][:thread_stack]        = "192K"
default[:mysql][:tunable][:thread_cache_size]   = "8"
default[:mysql][:tunable][:key_buffer]          = "250M"
default[:mysql][:tunable][:max_connections]     = "2048"
default[:mysql][:tunable][:wait_timeout]        = "180"
default[:mysql][:tunable][:net_read_timeout]    = "30"
default[:mysql][:tunable][:net_write_timeout]   = "30"
default[:mysql][:tunable][:back_log]            = "128"
default[:mysql][:tunable][:table_cache]         = "2048"
default[:mysql][:tunable][:max_heap_table_size] = "32M"
default[:mysql][:clients] = []

# Percona XtraDB
default[:mysql][:use_percona_xtradb] = false
default[:scalarium][:instance][:architecture] = `dpkg --print-architecture`.chomp

default[:percona] = {}
default[:percona][:tmp_dir] = '/tmp/percona-server'

if node[:platform] == 'ubuntu'
 case node[:platform_version].to_s
  when  '9.10'
    # this is the latest version with packages for Karmic
    default[:percona][:version] = '5.1.55-12.6'
  when '10.04', '11.04', '11.10'
    default[:percona][:version] = '5.1.57-12.8'
  else
    default[:percona][:version] = '5.5.24-rel26.0-256'
  end
end

default[:percona][:url_base] = "http://peritor-assets.s3.amazonaws.com/percona"
