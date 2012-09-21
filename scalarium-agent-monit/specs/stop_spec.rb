require 'minitest/spec'

describe_recipe 'scalarium-agent-monit::stop' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
