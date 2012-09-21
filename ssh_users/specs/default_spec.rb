require 'minitest/spec'

describe_recipe 'ssh_users::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
