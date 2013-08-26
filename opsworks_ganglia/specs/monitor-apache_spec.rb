require 'minitest/spec'

describe_recipe 'opsworks_ganglia::monitor-apache' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'installs logtail dep' do
    case node[:platform]
    when 'centos','redhat','fedora','amazon'
      package('logcheck').must_be_installed
    when 'debian','ubuntu'
      package('logtail').must_be_installed
    end
  end

  it 'creates /etc/ganglia/conf.d/apache.pyconf' do
    file('/etc/ganglia/conf.d/apache.pyconf').must_exist.with(:mode, '644')
  end

  it 'creates /etc/ganglia/python_modules/apache.py' do
    file('/etc/ganglia/python_modules/apache.py').must_exist.with(:mode, '644')
  end
end
