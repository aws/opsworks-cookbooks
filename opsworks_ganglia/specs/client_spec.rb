require 'minitest/spec'

describe_recipe 'opsworks_ganglia::client' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  describe 'ubuntu versions released in 2011' do
    it 'grabs custom deb files' do
      skip unless node[:platform] == 'ubuntu' && node[:platform_version].to_i == 11
      file('/tmp/ganglia-monitor.deb').must_exist
      file('/tmp/libganglia1.deb').must_exist
    end

    it 'installs libapr1 and libconfuse0' do
      skip unless node[:platform] == 'ubuntu' && node[:platform_version].to_i == 11
      package('libapr1').must_be_installed
      package('libconfuse0').must_be_installed
      if node[:platform_version].to_f == 11.04
        package('libpython2.7').must_be_installed
      end
    end

    it 'installs custom deb files' do
      skip unless node[:platform] == 'ubuntu' && node[:platform_version].to_i == 11
      package('libganglia1').must_be_installed
      package('ganglia-monitor').must_be_installed
    end
  end

  describe 'all other debian based systems' do
    it 'installs ganglia-monitor' do
      skip unless (node[:platform] == 'ubuntu' && node[:platform_version].to_i != 11) || (node[:platform] == 'debian')
      package('ganglia-monitor').must_be_installed
    end
  end

  describe 'rhel based systems' do
    it 'installs ganglia-gmond' do
      skip unless ['centos','redhat','fedora','amazon'].include?(node[:platform])
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
