include_attribute 'scalarium_initial_setup::default'

default[:opsworks_cleanup][:keep_logs] = 10
default[:opsworks_cleanup][:log_dir] = "#{node[:scalarium][:agent][:shared_dir]}/chef"
