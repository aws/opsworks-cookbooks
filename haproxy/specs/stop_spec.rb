require 'minitest/spec'

describe_recipe 'haproxy::stop' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'stops haproxy' do
    service('haproxy').wont_be_running
  end
end
