require 'minitest/spec'

describe_recipe 'scalarium_ganglia::monitor-fd-and-sockets' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
