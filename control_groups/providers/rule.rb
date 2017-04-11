def load_current_resource
  ControlGroups.rules_struct_init(node)
  new_resource.user new_resource.name unless new_resource.user
end

action :create do
  run_context.include_recipe 'control_groups::default'

  # create structure
  struct = {
    :controllers => new_resource.controllers,
    :destination => new_resource.destination
  }

  dest = node.run_state[:control_groups][:config][:structure][struct[:destination]]
  raise "Invalid destination provided for rule (dest: #{struct[:destination]})" unless dest

  # check for controllers
  struct[:controllers].each do |cont|
    unless(dest[cont])
      raise "Invalid controller provided for rule (controller: #{cont})"
    end
  end

  target = [new_resource.user, new_resource.command].compact.join(':')

  node.run_state[:control_groups][:rules][:active][target] = struct
end

action :delete do
  # Nothing \o/
end
