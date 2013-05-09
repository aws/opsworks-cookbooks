ruby_block "Execute the new cookbooks" do
  block do
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
