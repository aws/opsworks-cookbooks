require 'minitest/spec'

describe_recipe 'scalarium_ganglia::deploy' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
