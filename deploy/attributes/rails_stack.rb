default[:scalarium][:rails_stack][:name] = "apache_passenger"
case node[:scalarium][:rails_stack][:name]
when "apache_passenger"
  default[:scalarium][:rails_stack][:recipe] = "passenger_apache2::rails"
  default[:scalarium][:rails_stack][:needs_reload] = true
  default[:scalarium][:rails_stack][:service] = 'apache2'
  default[:scalarium][:rails_stack][:restart_command] = 'touch tmp/restart.txt'
when "nginx_unicorn"
  default[:scalarium][:rails_stack][:recipe] = "unicorn::rails"
  default[:scalarium][:rails_stack][:needs_reload] = true
  default[:scalarium][:rails_stack][:service] = 'unicorn'
  default[:scalarium][:rails_stack][:restart_command] = '../../shared/scripts/unicorn clean-restart'
else
  raise "Unknown stack: #{node[:scalarium][:rails_stack][:name].inspect}"
end
