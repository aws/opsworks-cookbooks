include ::RcMon::ProviderMethods

def load_current_resource
  new_resource.group_name new_resource.name unless new_resource.group_name
  run_context.include_recipe 'rc_mon'
end

RUNIT_ACTIONS = Chef::Resource::RunitService.new('rc_mon').instance_variable_get(:@allowed_actions).each do |action_name|
  action action_name.to_sym do
    runit_resource = build_runit_resource
    controls = configure_cgroups
    write_up_control(controls)
    write_run_file
    write_control_files
  end
end
