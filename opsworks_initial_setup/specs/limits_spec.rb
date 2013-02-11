require 'minitest/spec'

describe_recipe 'opsworks_initial_setup::limits' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'creates limits.conf' do
    file('/etc/security/limits.conf').must_exist.with(:owner, 'root').and(:group, 'root').and(:mode, '644')
  end

  it 'ensures limits.conf has right settings' do
    node[:opsworks_initial_setup][:limits].each do |key, value|
      unless value.nil?
        file('/etc/security/limits.conf').must_match /^root            hard    #{key}      #{value}$/
        file('/etc/security/limits.conf').must_match /^root            soft    #{key}      #{value}$/
        file('/etc/security/limits.conf').must_match /^\*               hard    #{key}      #{value}$/
        file('/etc/security/limits.conf').must_match /^\*               soft    #{key}      #{value}$/
      end
    end
  end
end
