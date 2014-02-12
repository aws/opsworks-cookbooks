include_attribute 'opsworks_initial_setup::default'

default[:opsworks_custom_cookbooks][:enabled] = false
default[:opsworks_custom_cookbooks][:user] = 'root'
default[:opsworks_custom_cookbooks][:group] = 'root'
default[:opsworks_custom_cookbooks][:home] = '/root'
# TODO: Eval cookbook_path out of Chef::Config[:config_file].
default[:opsworks_custom_cookbooks][:destination] = ::File.join(Chef::Config[:file_cache_path], '..', 'site-cookbooks')

default[:opsworks_custom_cookbooks][:recipes] = []

default[:opsworks_custom_cookbooks][:scm] = {}
default[:opsworks_custom_cookbooks][:scm][:type] = 'git'
default[:opsworks_custom_cookbooks][:scm][:user] = nil
default[:opsworks_custom_cookbooks][:scm][:password] = nil
default[:opsworks_custom_cookbooks][:scm][:ssh_key] = nil
default[:opsworks_custom_cookbooks][:scm][:repository] = nil

default[:opsworks_custom_cookbooks][:scm][:revision] = 'HEAD'
default[:opsworks_custom_cookbooks][:enable_submodules] = true
