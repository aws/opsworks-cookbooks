if node[:opsworks_custom_cookbooks][:enabled]
  include_recipe "opsworks_custom_cookbooks::checkout"
else
  directory node[:opsworks_custom_cookbooks][:destination] do
    action :delete
    recursive true
  end
end

ruby_block "Load the custom cookbooks" do
  block do
    if ::File.directory?(node[:opsworks_custom_cookbooks][:destination])
      Chef::Log.info("Loading custom cookbooks from #{node[:opsworks_custom_cookbooks][:destination]}")
      
      # add new Cookbooks and keep old
      Chef::Config.cookbook_path = [Chef::Config.cookbook_path, node[:opsworks_custom_cookbooks][:destination]].flatten
      
      # load the new cookbooks so that they can override our templates
      load_new_cookbooks
    end
  end
  
  only_if do
    Chef::Log.info("Loading custom cookbooks") if node[:opsworks_custom_cookbooks][:enabled]
    node[:opsworks_custom_cookbooks][:enabled]
  end
end
