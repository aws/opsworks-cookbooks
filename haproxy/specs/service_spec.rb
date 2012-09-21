require 'minitest/spec'

describe_recipe 'haproxy::service' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
