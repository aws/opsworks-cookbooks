Chef::Log.info("This recipe is depricated")

include_recipe "opsworks_custom_cookbooks::checkout"

ruby_block "load and execute the new cookbooks" do
  block do
    if ::File.directory?(node[:opsworks_custom_cookbooks][:destination])
      Chef::Log.info("Loading custom cookbooks from #{node[:opsworks_custom_cookbooks][:destination]}")
      
      # add new Cookbooks and keep old
      Chef::Config.cookbook_path = [Chef::Config.cookbook_path, node[:opsworks_custom_cookbooks][:destination]].flatten
      
      load_new_cookbooks

      node[:opsworks_custom_cookbooks][:recipes].each do |r|
        begin
          Chef::Log.info("Executing custom recipe: #{r}")
          include_recipe r
        rescue Exception => e
          Chef::Log.error("Caught exception during execution of custom recipe: #{r}: #{e.class} - #{e.message} - #{e.backtrace.join("\n")}")
          raise e
        end
      end
    end
  end
  
  only_if do
    Chef::Log.info("Loading and executing custom cookbooks") if node[:opsworks_custom_cookbooks][:enabled]
    node[:opsworks_custom_cookbooks][:enabled]
  end
end
