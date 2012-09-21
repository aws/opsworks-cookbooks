require 'minitest/spec'

describe_recipe 'scalarium_initial_setup::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
