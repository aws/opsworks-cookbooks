require 'minitest/spec'

describe_recipe 'haproxy::configure' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'ensures haproxy is running' do
    service('haproxy').must_be_running
  end
end
