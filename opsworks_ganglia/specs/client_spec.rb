require 'minitest/spec'

describe_recipe 'opsworks_ganglia::client' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'installs ganglia monitor deamon' do
    case node[:platform_family]
    when 'debian'
      package('ganglia-monitor').must_be_installed
    when "rhel"
      package('ganglia-gmond').must_be_installed
    end
  end

   it 'creates /etc/ganglia/scripts directory' do
    directory('/etc/ganglia/scripts').must_exist.with(:owner, 'root').and(:group, 'root').and(:mode, '755')
  end

  it 'creates /etc/ganglia/conf.d' do
    directory('/etc/ganglia/conf.d').must_exist.with(:owner, 'root').and(:group, 'root').and(:mode, '755')
  end

  it 'creates /etc/ganglia/python_modules' do
    directory('/etc/ganglia/python_modules').must_exist.with(:owner, 'root').and(:group, 'root').and(:mode, '755')
  end
end
