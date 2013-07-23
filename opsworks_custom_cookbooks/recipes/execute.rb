Chef::Log.info "OpsWorks Custom Run List: #{node[:opsworks_custom_cookbooks][:recipes].inspect}"

ruby_block("Compile Custom OpsWorks Run List") do
  block do
    begin

      opsworks_run_list = Chef::RunList.new(*node[:opsworks_custom_cookbooks][:recipes])
      Chef::Log.info "New Run List expands to #{opsworks_run_list.run_list_items.map(&:name).inspect}"

      # Reload and rerun after custom cookbooks have been added to the filesystem
      cl = Chef::CookbookLoader.new(Chef::Config[:cookbook_path])
      cl.load_cookbooks
      cookbook_collection = Chef::CookbookCollection.new(cl)
      custom_cookbook_run_context = Chef::RunContext.new(self.run_context.node, cookbook_collection, self.run_context.events)
      custom_cookbook_run_context.load(opsworks_run_list)

    rescue Exception => e
      Chef::Log.error "Caught exception while compiling opsworks custom run list: #{e.class} - #{e.message} - #{e.backtrace.join("\n")}"
      raise e
    end

    custom_cookbook_runner = Chef::Runner.new(custom_cookbook_run_context)
    custom_cookbook_runner.converge
  end
end
