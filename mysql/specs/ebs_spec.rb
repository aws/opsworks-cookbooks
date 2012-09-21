require 'minitest/spec'

describe_recipe 'mysql::ebs' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
