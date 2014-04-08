package "opsworks-berkshelf" do
  action :remove
  ignore_failure true
end

ruby_block "Uninstall other versions of berkshelf" do
  block do
    uninstall_other_gem_versions('berkshelf', node['opsworks_berkshelf']['version'])
  end
end

gem_package "berkshelf" do
  gem_binary Opsworks::InstanceAgent::Environment.gem_binary

  action :purge
  only_if do
    `#{Opsworks::InstanceAgent::Environment.gem_binary} search -i berkshelf`
  end
end

log "delete repo" do
  message "Deleting cookbooks previously managed by Berkshelf."
  action :nothing
end

directory Opsworks::InstanceAgent::Environment.berkshelf_cookbooks_path do
  action :delete
  recursive true
  notifies :write, "log[delete repo]", :immediately

  not_if do
    node[:opsworks_custom_cookbooks].has_key?(:manage_berkshelf) && node[:opsworks_custom_cookbooks][:manage_berkshelf]
  end
end
