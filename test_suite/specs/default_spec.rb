require 'minitest/spec'

describe_recipe 'test_suite::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
