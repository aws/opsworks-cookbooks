require 'minitest/spec'

describe_recipe 'mysql::client' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
