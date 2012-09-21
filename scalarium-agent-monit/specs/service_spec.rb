require 'minitest/spec'

describe_recipe 'scalarium-agent-monit::service' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
