require 'minitest/spec'

describe_recipe 'mysql::apparmor', :if => ['debian', 'ubuntu'].include?(node[:platform]) do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'starts apparmor' do
    service('apparmor').must_be_running
  end

  it 'installs apparmor profile for mysql' do
    file('/etc/apparmor.d/usr.sbin.mysqld').must_exist.with(:owner, 'root').and(:group, 'root').and(:mode, '644')
  end
end
