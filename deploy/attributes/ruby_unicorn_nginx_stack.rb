default[:opsworks][:ruby_unicorn_nginx_stack][:recipe] = "unicorn::ruby_unicorn_nginx"
default[:opsworks][:ruby_unicorn_nginx_stack][:needs_reload] = true
default[:opsworks][:ruby_unicorn_nginx_stack][:service] = 'unicorn'
default[:opsworks][:ruby_unicorn_nginx_stack][:restart_command] = "../../shared/scripts/unicorn restart"