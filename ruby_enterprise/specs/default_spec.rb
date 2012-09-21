require 'minitest/spec'

describe_recipe 'ruby_enterprise::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
