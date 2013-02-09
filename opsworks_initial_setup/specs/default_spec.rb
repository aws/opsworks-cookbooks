require 'minitest/spec'

describe_recipe 'opsworks_initial_setup::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
