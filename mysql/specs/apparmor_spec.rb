require 'minitest/spec'

describe_recipe 'mysql::apparmor' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'starts apparmor' do
    skip unless ['debian','ubuntu'].include?(node[:platform])
    service('apparmor').must_be_running
  end

  it 'installs apparmor profile for mysql' do
    skip unless ['debian','ubuntu'].include?(node[:platform])
    file('/etc/apparmor.d/usr.sbin.mysqld').must_exist.with(:owner, 'root').and(:group, 'root').and(:mode, '644')
  end
end
