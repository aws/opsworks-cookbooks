require 'minitest/spec'

describe_recipe 'scalarium_initial_setup::setup_cookbook_tests_env' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
