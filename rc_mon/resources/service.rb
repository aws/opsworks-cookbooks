RUNIT_ACTIONS = Chef::Resource::RunitService.new('rc_mon').instance_variable_get(:@allowed_actions).map(&:to_sym)

default_action :enable
actions *RUNIT_ACTIONS

attr_reader :runit_attributes

attribute :group_name, :kind_of => String
attribute :command, :kind_of => String
attribute :memory_limit, :kind_of => [String,Numeric]
attribute :swap_limit, :kind_of => [String,Numeric]
attribute :cpu_shares, :kind_of => Numeric
attribute :control_user, :kind_of => String
attribute :control_group, :kind_of => String
attribute :start_command, :kind_of => String
attribute :stop_command, :kind_of => String

def method_missing(*args)
  if(args.size != 2 || args.first.to_s.end_with?('='))
    super
  else
    @runit_attributes ||= Mash.new
    @runit_attributes[args.first] = args.last
  end
end
