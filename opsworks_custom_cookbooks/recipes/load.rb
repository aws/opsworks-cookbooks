if node[:opsworks_custom_cookbooks][:enabled]
  include_recipe "opsworks_custom_cookbooks::checkout"
else
  directory node[:opsworks_custom_cookbooks][:destination] do
    action :delete
    recursive true

    only_if {node[:opsworks_custom_cookbooks][:destination]}
  end
end

ruby_block 'merge all cookbooks sources' do
  block do
     FileUtils.rm_rf OpsworksInstanceAgentConfig.merged_cookbooks_path
     FileUtils.cp_r OpsworksInstanceAgentConfig.default_cookbooks_path, OpsworksInstanceAgentConfig.merged_cookbooks_path
     FileUtils.cp_r "#{OpsworksInstanceAgentConfig.berkshelf_cookbooks_path}/.", OpsworksInstanceAgentConfig.merged_cookbooks_path if ::File.directory?(OpsworksInstanceAgentConfig.berkshelf_cookbooks_path)
     FileUtils.cp_r "#{OpsworksInstanceAgentConfig.site_cookbooks_path}/.", OpsworksInstanceAgentConfig.merged_cookbooks_path if ::File.directory?(OpsworksInstanceAgentConfig.site_cookbooks_path)
  end
end
