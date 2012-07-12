include_recipe "scalarium_initial_setup::sysctl"
include_recipe 'scalarium_initial_setup::limits'
include_recipe "scalarium_initial_setup::bind_mounts"
include_recipe "scalarium_initial_setup::remove_landscape"