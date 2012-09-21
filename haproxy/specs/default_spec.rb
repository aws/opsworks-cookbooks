require 'minitest/spec'

describe_recipe 'haproxy::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
