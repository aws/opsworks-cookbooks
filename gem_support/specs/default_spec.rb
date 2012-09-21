require 'minitest/spec'

describe_recipe 'gem_support::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
