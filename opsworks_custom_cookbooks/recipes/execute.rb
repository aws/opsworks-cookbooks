Chef::Log.info "OpsWorks Custom Run List: #{node[:opsworks_custom_cookbooks][:recipes].inspect}"

ruby_block("Compile Custom OpsWorks Run List") do
  block do
    begin

      # Reload cookbooks after they're available on local filesystem
      cl = Chef::CookbookLoader.new(Chef::Config[:cookbook_path])
      cl.load_cookbooks
      self.run_context.instance_variable_set(:@cookbook_collection, Chef::CookbookCollection.new(cl))

      # Expand run list with custom cookbooks and load them into the current run_context
      opsworks_run_list = Chef::RunList.new(*node[:opsworks_custom_cookbooks][:recipes])
      Chef::Log.info "New Run List expands to #{opsworks_run_list.run_list_items.map(&:name).inspect}"
      self.run_context.load(opsworks_run_list)

    rescue Exception => e
      Chef::Log.error "Caught exception while compiling OpsWorks custom run list: #{e.class} - #{e.message} - #{e.backtrace.join("\n")}"
      raise e
    end

  end
end
