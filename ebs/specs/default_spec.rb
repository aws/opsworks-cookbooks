require 'minitest/spec'

describe_recipe 'ebs::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
