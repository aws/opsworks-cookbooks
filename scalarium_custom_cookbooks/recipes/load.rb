include_recipe "scalarium_custom_cookbooks::checkout"

ruby_block "Load the custom cookbooks" do
  block do
    if ::File.directory?(node[:scalarium_custom_cookbooks][:destination])
      Chef::Log.info("Loading custom cookbooks from #{node[:scalarium_custom_cookbooks][:destination]}")
      
      # add new Cookbooks and keep old
      Chef::Config.cookbook_path = [Chef::Config.cookbook_path, node[:scalarium_custom_cookbooks][:destination]].flatten
      
      # load the new cookbooks so that they can override our templates
      load_new_cookbooks
    end
  end
  
  only_if do
    Chef::Log.info("Loading custom cookbooks") if node[:scalarium_custom_cookbooks][:enabled]
    node[:scalarium_custom_cookbooks][:enabled]
  end
end
