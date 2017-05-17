normal[:opsworks][:ruby_unicorn_nginx_stack][:recipe] = "unicorn::ruby_unicorn_nginx"
normal[:opsworks][:ruby_unicorn_nginx_stack][:needs_reload] = true
normal[:opsworks][:ruby_unicorn_nginx_stack][:service] = 'unicorn'
normal[:opsworks][:ruby_unicorn_nginx_stack][:restart_command] = "../../shared/scripts/unicorn restart"