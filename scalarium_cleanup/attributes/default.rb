include_attribute 'scalarium_cluster_state'

default[:scalarium_cleanup][:keep_logs] = 5
default[:scalarium_cleanup][:log_dir] = "#{node[:scalarium_agent_root]}/log/chef"
