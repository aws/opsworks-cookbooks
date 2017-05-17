node[:opsworks][:ruby_unicorn_nginx_stack][:name] = "unicorn::ruby_unicorn_nginx"
node[:opsworks][:ruby_unicorn_nginx_stack][:recipe] = "unicorn::ruby_unicorn_nginx"
node[:opsworks][:ruby_unicorn_nginx_stack][:needs_reload] = true
node[:opsworks][:ruby_unicorn_nginx_stack][:service] = 'unicorn'
node[:opsworks][:ruby_unicorn_nginx_stack][:restart_command] = "../../shared/scripts/unicorn restart"