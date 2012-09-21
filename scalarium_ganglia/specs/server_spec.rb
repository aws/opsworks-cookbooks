require 'minitest/spec'

describe_recipe 'scalarium_ganglia::server' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
