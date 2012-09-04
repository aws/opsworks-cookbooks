include_attribute 'rails::rails'

case node[:scalarium][:ruby_version]
when /1.8/
  default[:passenger][:gems_path] = '/usr/local/lib/ruby/gems/1.8/gems'
else
  default[:passenger][:gems_path] = '/usr/local/lib/ruby/gems/1.9.1/gems'
end

default[:passenger][:version] = '3.0.9'
default[:passenger][:root_path] = "#{node[:passenger][:gems_path]}/passenger-#{passenger[:version]}"
default[:passenger][:module_path] = "#{passenger[:root_path]}/ext/apache2/mod_passenger.so"
default[:passenger][:ruby_bin] = '/usr/local/bin/ruby'
default[:passenger][:ruby_wrapper_bin] = '/usr/local/bin/ruby_gc_wrapper.sh'
default[:passenger][:gem_bin] = '/usr/local/bin/gem'
default[:passenger][:stat_throttle_rate] = 5
default[:passenger][:rails_framework_spawner_idle_time] = 0
default[:passenger][:rails_app_spawner_idle_time] = 0
default[:passenger][:pool_idle_time] = 14400 # 4 hours
default[:passenger][:max_instances_per_app] = 0
default[:passenger][:max_requests] = 0
default[:passenger][:high_performance_mode] = 'off'
default[:passenger][:rails_spawn_method] = 'smart-lv2'
default[:passenger][:max_pool_size] = 8 # usually will be set by Scalarium directy. Override if you need a custom size
