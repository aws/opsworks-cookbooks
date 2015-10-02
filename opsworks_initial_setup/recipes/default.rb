if node[:ec2] && (node[:ec2][:instance_type] == 't1.micro' ||
                  node['opsworks_initial_setup']['swapfile_instancetypes'] && node['opsworks_initial_setup']['swapfile_instancetypes'].include?(node[:ec2][:instance_type]))
  include_recipe 'opsworks_initial_setup::swap'
end

include_recipe 'opsworks_initial_setup::sysctl'
include_recipe 'opsworks_initial_setup::limits'
if infrastructure_class?('ec2')
  include_recipe 'opsworks_initial_setup::bind_mounts'
  include_recipe 'opsworks_initial_setup::vol_mount_point'
end
include_recipe 'opsworks_initial_setup::remove_landscape'
include_recipe 'opsworks_initial_setup::ldconfig'

include_recipe 'opsworks_initial_setup::yum_conf'
include_recipe 'opsworks_initial_setup::tweak_chef_yum_dump'
include_recipe 'opsworks_initial_setup::setup_rhel_repos'

include_recipe 'opsworks_initial_setup::package_procps'
include_recipe 'opsworks_initial_setup::package_ntpd'
include_recipe 'opsworks_initial_setup::package_vim'
include_recipe 'opsworks_initial_setup::package_sqlite'
include_recipe 'opsworks_initial_setup::package_screen'
