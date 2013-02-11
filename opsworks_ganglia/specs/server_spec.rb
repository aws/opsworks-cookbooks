require 'minitest/spec'

describe_recipe 'opsworks_ganglia::server' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  describe 'ubuntu versions released in 2011' do
    it 'grabs gmetad deb' do
      skip unless node[:platform] == 'ubuntu' && node[:platform_version].to_i == 11
      file('/tmp/gmetad.deb').must_exist
    end

    it 'installs librrd4' do
      skip unless node[:platform] == 'ubuntu' && node[:platform_version].to_i == 11
      package('librrd4').must_be_installed
    end
  end

  it 'installs gmetad' do
    case node[:platform]
    when "debian","ubuntu"
      package('gmetad').must_be_installed
    when 'centos','redhat','fedora','amazon'
      package('ganglia-gmetad').must_be_installed
    end
  end

  it 'creates gmetad.conf' do
    file('/etc/ganglia/gmetad.conf').must_exist.with(:mode, '644')
  end

  it 'has stack name in gmetad.conf' do
    file('/etc/ganglia/gmetad.conf').must_include node[:opsworks][:stack][:name]
  end

  it 'starts and enables gmetad' do
    service('gmetad').must_be_running
    service('gmetad').must_be_enabled
  end
end
