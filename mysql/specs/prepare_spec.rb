require 'minitest/spec'

describe_recipe 'mysql::prepare' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'makes sure /var/cache/local/preseeding exists' do
    skip unless ['debian','ubuntu'].include?(node[:platform])
    directory('/var/cache/local/preseeding').must_exist.with(:owner, 'root').and(
      :group, 'root').and(:mode, '755')
  end

  it 'creates mysql-server.seed for preseeding values in debconf' do
    skip unless ['debian','ubuntu'].include?(node[:platform])
    file('/var/cache/local/preseeding/mysql-server.seed').must_exist.with(
      :mode, '600').and(:owner, 'root').and(:group, 'root')
  end

  it 'must include the correct values in mysql-server.seed' do
    skip unless ['debian','ubuntu'].include?(node[:platform])
    file('/var/cache/local/preseeding/mysql-server.seed').must_include(
      node[:mysql][:server_root_password])
  end
end
