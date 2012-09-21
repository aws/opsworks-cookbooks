require 'minitest/spec'

describe_recipe 'mysql::apparmor' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
