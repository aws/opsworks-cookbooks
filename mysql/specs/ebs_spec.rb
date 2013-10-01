require 'minitest/spec'

describe_recipe 'mysql::ebs' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'should have directory for data' do
    directory(node[:mysql][:ec2_path]).must_exist.with(:owner, node[:mysql][:user]).and(
      :group, node[:mysql][:group])
  end

  it 'should cover the data directory by an autofs map' do
    assert system("automount -m | grep '#{node[:mysql][:datadir]} | -fstype=none,bind,rw :#{node[:mysql][:ec2_path]}'")
  end

  it 'should have a directory for logs' do
    directory(node[:mysql][:logdir]).must_exist.with(:owner, node[:mysql][:user]).and(
      :group, node[:mysql][:group])
  end

  it 'should cover the log directory by an autofs map' do
    assert system("automount -m | grep '#{node[:mysql][:logdir]} | -fstype=none,bind,rw'")
  end
end
