require 'minitest/spec'

describe_recipe 'ssh_host_keys::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
