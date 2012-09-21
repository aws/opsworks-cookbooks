require 'minitest/spec'

describe_recipe 'mysql::config' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
