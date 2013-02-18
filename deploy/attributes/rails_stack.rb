default[:opsworks][:rails_stack][:name] = "apache_passenger"
case node[:opsworks][:rails_stack][:name]
when "apache_passenger"
  default[:opsworks][:rails_stack][:recipe] = "passenger_apache2::rails"
  default[:opsworks][:rails_stack][:needs_reload] = true
  default[:opsworks][:rails_stack][:service] = 'apache2'
  default[:opsworks][:rails_stack][:restart_command] = 'touch tmp/restart.txt'
when "nginx_unicorn"
  default[:opsworks][:rails_stack][:recipe] = "unicorn::rails"
  default[:opsworks][:rails_stack][:needs_reload] = true
  default[:opsworks][:rails_stack][:service] = 'unicorn'
  default[:opsworks][:rails_stack][:restart_command] = '../../shared/scripts/unicorn clean-restart'
else
  raise "Unknown stack: #{node[:opsworks][:rails_stack][:name].inspect}"
end
