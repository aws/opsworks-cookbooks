require 'openssl'

pw = String.new

while pw.length < 20
  pw << OpenSSL::Random.random_bytes(1).gsub(/\W/, '')
end

set_unless[:mysql][:server_root_password] = pw
set_unless[:mysql][:bind_address]         = '0.0.0.0'
set_unless[:mysql][:datadir]              = "/var/lib/mysql"

if attribute?(:ec2)
  set_unless[:mysql][:ec2_path]    = "/mnt/mysql"
end

# Tunables

# InnoDB
set_unless[:mysql][:tunable][:innodb_buffer_pool_size]         = "1200M"
set_unless[:mysql][:tunable][:innodb_additional_mem_pool_size] = "20M"
set_unless[:mysql][:tunable][:innodb_flush_log_at_trx_commit]  = "2"
set_unless[:mysql][:tunable][:innodb_lock_wait_timeout]        = "50"

# query cache
set_unless[:mysql][:tunable][:query_cache_type]    = "1"
set_unless[:mysql][:tunable][:query_cache_size]    = "128M"
set_unless[:mysql][:tunable][:query_cache_limit]   = "2M"

# MyISAM & general
set_unless[:mysql][:tunable][:max_allowed_packet]  = "32M"
set_unless[:mysql][:tunable][:thread_stack]        = "192K"
set_unless[:mysql][:tunable][:thread_cache_size]   = "8"
set_unless[:mysql][:tunable][:key_buffer]          = "250M"
set_unless[:mysql][:tunable][:max_connections]     = "1024"
set_unless[:mysql][:tunable][:wait_timeout]        = "180"
set_unless[:mysql][:tunable][:net_read_timeout]    = "30"
set_unless[:mysql][:tunable][:net_write_timeout]   = "30"
set_unless[:mysql][:tunable][:back_log]            = "128"
set_unless[:mysql][:tunable][:table_cache]         = "1024"
set_unless[:mysql][:tunable][:max_heap_table_size] = "32M"
set_unless[:mysql][:clients] = []

# Percona XtraDB
set_unless[:mysql][:use_percona_xtradb] = false
set_unless[:scalarium][:instance][:architecture] = `dpkg --print-architecture`.chomp

set_unless[:percona] = {}
set_unless[:percona][:tmp_dir] = '/tmp/percona-server'
set_unless[:percona][:version] = '5.1.47-11.2-53'
set_unless[:percona][:url_base] = "http://peritor-assets.s3.amazonaws.com/percona"