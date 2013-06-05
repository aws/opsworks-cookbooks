Chef::Log.info "OpsWorks Custom Run List: #{node[:opsworks_custom_cookbooks][:recipes].inspect}"

ruby_block("Compile Custom OpsWorks Run List") do
  block do
    begin

      opsworks_run_list = Chef::RunList.new(*node[:opsworks_custom_cookbooks][:recipes])
      Chef::Log.info "New Run List expands to #{opsworks_run_list.run_list_items.map(&:name).inspect}"

      self.run_context.load(opsworks_run_list)

    rescue Exception => e
      Chef::Log.error "Caught exception while compiling opsworks custom run list: #{e.class} - #{e.message} - #{e.backtrace.join("\n")}"
      raise e
    end
  end
end
