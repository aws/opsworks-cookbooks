require 'minitest/spec'

describe_recipe 'scalarium_rubygems::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
