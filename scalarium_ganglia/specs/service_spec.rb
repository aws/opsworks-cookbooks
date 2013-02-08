require 'minitest/spec'

describe_recipe 'scalarium_ganglia::service' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions
# TODO: service is installed
# TODO: service is enabled
end
