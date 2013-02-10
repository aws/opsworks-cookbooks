require 'minitest/spec'

describe_recipe 'opsworks_ganglia::service-gmetad' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
