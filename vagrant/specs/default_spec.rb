require 'minitest/spec'

describe_recipe 'vagrant::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
