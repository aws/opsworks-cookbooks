require 'minitest/spec'

describe_recipe 'scalarium_ganglia::custom-install' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
