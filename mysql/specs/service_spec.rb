require 'minitest/spec'

describe_recipe 'mysql::service' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
