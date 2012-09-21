require 'minitest/spec'

describe_recipe 'haproxy::stop' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
