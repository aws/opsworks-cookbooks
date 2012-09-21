require 'minitest/spec'

describe_recipe 'scalarium_ganglia::bind-mount-data' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
