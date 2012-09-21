require 'minitest/spec'

describe_recipe 'mysql::server' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
