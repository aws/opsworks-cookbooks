require 'minitest/spec'

describe_recipe 'scalarium_initial_setup::limits' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'creates limits.conf' do
    file('/etc/security/limits.conf').must_exist.with(:owner, 'root').and(:group, 'root').and(:mode, '644')
  end

  it 'ensures limits.conf has right settings' do
    node[:scalarium_initial_setup][:limits].each do |key, value|
      unless value.nil?
        file('/etc/security/limits.conf').must_include key
        file('/etc/security/limits.conf').must_include value
      end
    end
  end
end
