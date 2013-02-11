include_attribute 'opsworks_initial_setup::default'

default[:opsworks_custom_cookbooks][:enabled] = false
default[:opsworks_custom_cookbooks][:user] = 'root'
default[:opsworks_custom_cookbooks][:group] = 'root'
default[:opsworks_custom_cookbooks][:home] = '/root'
default[:opsworks_custom_cookbooks][:destination] = "#{node[:opsworks_agent][:current_dir]}/site-cookbooks"

default[:opsworks_custom_cookbooks][:recipes] = []

default[:opsworks_custom_cookbooks][:scm] = {}
default[:opsworks_custom_cookbooks][:scm][:type] = 'git'
default[:opsworks_custom_cookbooks][:scm][:user] = nil
default[:opsworks_custom_cookbooks][:scm][:password] = nil
default[:opsworks_custom_cookbooks][:scm][:ssh_key] = nil
default[:opsworks_custom_cookbooks][:scm][:repository] = nil

default[:opsworks_custom_cookbooks][:scm][:revision] = 'HEAD'
default[:opsworks_custom_cookbooks][:enable_submodules] = true
