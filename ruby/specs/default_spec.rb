require 'minitest/spec'

describe_recipe 'ruby::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
