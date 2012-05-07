include_attribute 'rails::rails'

default[:unicorn][:worker_processes] = node[:rails][:max_pool_size] ? node[:rails][:max_pool_size] : 4
default[:unicorn][:backlog] = 1024
default[:unicorn][:timeout] = 60
default[:unicorn][:preload_app] = true
default[:unicorn][:version] = '4.0.1'
default[:unicorn][:tcp_nodelay] = true
default[:unicorn][:tcp_nopush] = false
default[:unicorn][:tries] = 5
default[:unicorn][:delay] = 0.5
default[:unicorn][:accept_filter] = "httpready"