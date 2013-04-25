if node[:sinatra] || node[:web_application_type] == 'sinatra'
  include_attribute 'sinatra::default'
elsif node[:rails] || node[:web_application_type] == 'rails'
  include_attribute 'rails'
end

default[:unicorn][:worker_processes] = if node[:rails] && node[:rails][:max_pool_size]
  node[:rails][:max_pool_size]
elsif node[:rack] && node[:rack][:max_pool_size]
  node[:rack][:max_pool_size]
elsif node[:sinatra] && node[:sinatra][:max_pool_size]
  node[:sinatra][:max_pool_size]
else
  4
end
default[:unicorn][:backlog] = 1024
default[:unicorn][:timeout] = 60
default[:unicorn][:preload_app] = true
default[:unicorn][:version] = '4.0.1'
default[:unicorn][:tcp_nodelay] = true
default[:unicorn][:tcp_nopush] = false
default[:unicorn][:tries] = 5
default[:unicorn][:delay] = 0.5
default[:unicorn][:accept_filter] = "httpready"