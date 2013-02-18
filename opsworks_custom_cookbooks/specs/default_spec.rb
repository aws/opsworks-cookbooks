require 'minitest/spec'

describe_recipe 'opsworks_custom_cookbooks::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
