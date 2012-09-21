require 'minitest/spec'

describe_recipe 'nginx::uninstall' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
