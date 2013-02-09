require 'minitest/spec'

describe_recipe 'opsworks_initial_setup::sysctl' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'creates sysctl.d' do
    directory('/etc/sysctl.d').must_exist.with(:mode, '755').and(:owner, 'root').and(:group, 'root')
  end

  it 'creates opsworks sysctl defaults' do
    file('/etc/sysctl.d/70-opsworks-defaults.conf').must_exist.with(:owner, 'root').and(:group, 'root').and(:mode, '644')
  end

  it 'sets sysctl values' do
    node[:opsworks_initial_setup][:sysctl].each do |systcl, value|
      assert system("sysctl -a | grep '#{systcl}' | grep #{value}")
    end
  end
end
