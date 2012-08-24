include_recipe "scalarium_initial_setup::sysctl"
include_recipe 'scalarium_initial_setup::limits'
include_recipe "scalarium_initial_setup::bind_mounts"
include_recipe "scalarium_initial_setup::remove_landscape"

include_recipe "scalarium_initial_setup::setup_cookbook_tests_env" if node[:scalarium][:run_cookbook_tests]
