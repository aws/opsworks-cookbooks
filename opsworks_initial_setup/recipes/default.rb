include_recipe 'opsworks_initial_setup::swap' if node[:ec2] && node[:ec2][:instance_type] == 't1.micro'
include_recipe 'opsworks_initial_setup::sysctl'
include_recipe 'opsworks_initial_setup::limits'
include_recipe 'opsworks_initial_setup::bind_mounts'
include_recipe 'opsworks_initial_setup::vol_mount_point'
include_recipe 'opsworks_initial_setup::remove_landscape'
include_recipe 'opsworks_initial_setup::ldconfig'

case node["platform_family"]
when "rhel"
include_recipe 'opsworks_initial_setup::yum_conf'
include_recipe 'opsworks_initial_setup::tweak_chef_yum_dump'
include_recipe 'opsworks_initial_setup::setup_rhel_repos'
end

include_recipe 'opsworks_initial_setup::package_procps'
include_recipe 'opsworks_initial_setup::package_ntpd'
include_recipe 'opsworks_initial_setup::package_vim'
include_recipe 'opsworks_initial_setup::package_sqlite'
include_recipe 'opsworks_initial_setup::package_screen'
