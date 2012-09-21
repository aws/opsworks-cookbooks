require 'minitest/spec'

describe_recipe 'unicorn::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
