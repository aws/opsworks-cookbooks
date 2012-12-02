include_recipe 'scalarium_initial_setup::sysctl'
include_recipe 'scalarium_initial_setup::limits'
include_recipe 'scalarium_initial_setup::bind_mounts'
include_recipe 'scalarium_initial_setup::remove_landscape'

include_recipe 'scalarium_initial_setup::setup_rhel_repos'

include_recipe 'scalarium_initial_setup::package_procps'
include_recipe 'scalarium_initial_setup::package_ntpd'
include_recipe 'scalarium_initial_setup::package_vim'
include_recipe 'scalarium_initial_setup::package_zsh'
include_recipe 'scalarium_initial_setup::package_sqlite'
include_recipe 'scalarium_initial_setup::package_screen'
