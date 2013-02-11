require 'minitest/spec'

describe_recipe 'opsworks_ganglia::monitor-nginx' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
