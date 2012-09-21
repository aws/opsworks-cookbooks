require 'minitest/spec'

describe_recipe 'mysql::stop' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
