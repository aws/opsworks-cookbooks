require 'minitest/spec'

describe_recipe 'nginx::service' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
