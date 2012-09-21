require 'minitest/spec'

describe_recipe 'scalarium_nodejs::npm' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
