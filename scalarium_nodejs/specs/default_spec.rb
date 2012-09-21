require 'minitest/spec'

describe_recipe 'scalarium_nodejs::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
