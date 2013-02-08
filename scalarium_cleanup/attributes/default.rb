include_attribute 'scalarium_initial_setup::default'

default[:scalarium_cleanup][:keep_logs] = 5
default[:scalarium_cleanup][:log_dir] = "#{node[:scalarium][:agent][:shared_dir]}/log/chef"
