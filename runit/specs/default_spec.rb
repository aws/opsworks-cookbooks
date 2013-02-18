require 'minitest/spec'

describe_recipe 'runit::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
