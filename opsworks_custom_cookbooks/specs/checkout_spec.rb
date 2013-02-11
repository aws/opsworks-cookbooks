require 'minitest/spec'

describe_recipe 'opsworks_custom_cookbooks::checkout' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
