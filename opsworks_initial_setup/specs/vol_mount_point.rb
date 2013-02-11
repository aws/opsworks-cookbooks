require 'minitest/spec'

describe_recipe 'opsworks_initial_setup::vol_mount_point' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'creates directory /vol' do
    directory('/vol').must_exist.with(:mode, '755')
  end
end
