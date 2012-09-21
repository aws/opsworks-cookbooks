require 'minitest/spec'

describe_recipe 'deploy::web' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
