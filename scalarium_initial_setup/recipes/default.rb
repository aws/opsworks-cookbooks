include_recipe "scalarium_initial_setup::sysctl"
include_recipe 'scalarium_initial_setup::limits'
include_recipe "scalarium_initial_setup::bind_mounts"
include_recipe "scalarium_initial_setup::remove_landscape"

if %w{centos rhel amazon opensuse fedora}.include?(node[:platform])
  include_recipe "scalarium_initial_setup::setup_rhel_repos"
end

if node[:scalarium][:run_cookbook_tests]
  Chef::Log.info("Initializing Cookbook Test Environment.")
  include_recipe "scalarium_initial_setup::setup_cookbook_tests_env"
end
