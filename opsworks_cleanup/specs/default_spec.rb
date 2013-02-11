require 'minitest/spec'

describe_recipe 'opsworks_cleanup::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
