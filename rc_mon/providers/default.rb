include ::RcMon::ProviderMethods

def load_current_resource
  new_resource.runit_name new_resource.name unless new_resource.runit_name
  new_resource.group_name new_resource.name unless new_resource.group_name
  run_context.include_recipe 'rc_mon'
end

action :enable do
  @runit_resource = new_resource.run_context.resource_collection.lookup("runit_service[#{new_resource.runit_name}]")
  controls = configure_cgroups
  write_up_control(controls)
end

action :disable do
  @runit_resource = new_resource.run_context.resource_collection.lookup("runit_service[#{new_resource.runit_name}]")
  write_up_control([], :delete)
end
