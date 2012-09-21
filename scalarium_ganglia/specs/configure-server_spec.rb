require 'minitest/spec'

describe_recipe 'scalarium_ganglia::configure-server' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
