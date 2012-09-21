require 'minitest/spec'

describe_recipe 'deploy::nodejs' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
