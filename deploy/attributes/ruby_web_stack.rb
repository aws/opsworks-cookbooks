default[:opsworks][:ruby_web_stack][:name] = "nginx_unicorn"
case node[:opsworks][:ruby_web_stack][:name]
  when "nginx_unicorn"
    normal[:opsworks][:ruby_web_stack][:recipe] = "unicorn::ruby_web"
    normal[:opsworks][:ruby_web_stack][:needs_reload] = true
    normal[:opsworks][:ruby_web_stack][:service] = 'unicorn'
    normal[:opsworks][:ruby_web_stack][:restart_command] = "../../shared/scripts/unicorn restart"
  else
    raise "Unknown stack: #{node[:opsworks][:ruby_web_stack][:name].inspect}"
end
