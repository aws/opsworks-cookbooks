require 'minitest/spec'

describe_recipe 'scalarium_cleanup::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
