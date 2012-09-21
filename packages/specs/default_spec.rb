require 'minitest/spec'

describe_recipe 'packages::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
