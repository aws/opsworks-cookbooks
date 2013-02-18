require 'minitest/spec'

describe_recipe 'ssh_users::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'creates opsworks group' do
    group('opsworks').must_exist
  end

  it 'sets up sudoers file' do
    file('/etc/sudoers').must_exist.with(:owner, 'root').and(:group, 'root').and(:mode, '440')
  end

  it 'includes the sudoers' do
    node[:sudoers].each do |sudoer|
      file('/etc/sudoers').must_include sudoer[:name]
    end
  end
end
