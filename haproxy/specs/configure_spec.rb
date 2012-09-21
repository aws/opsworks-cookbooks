require 'minitest/spec'

describe_recipe 'haproxy::configure' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
