require 'minitest/spec'

describe_recipe 'deploy::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
