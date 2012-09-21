require 'minitest/spec'

describe_recipe 'deploy::php' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
