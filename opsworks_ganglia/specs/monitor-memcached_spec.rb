require 'minitest/spec'

describe_recipe 'opsworks_ganglia::monitor-memcached' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'installs deps' do
    case node[:platform]
    when "centos","redhat","fedora","scientific","amazon","oracle"
      package('perl-XML-Simple').must_be_installed
      package('perl-Cache-Memcached').must_be_installed
    when "debian","ubuntu"
      package('libxml-simple-perl').must_be_installed
      package('libcache-memcached-perl').must_be_installed
    end
  end

  it 'creates memcached monitor script' do
    file('/etc/ganglia/scripts/memcached').must_exist.with(:owner, 'root').and(:group, 'root').and(:mode, '755')
  end

  it 'creates memcached monitor cron' do
    cron("Ganglia Memcached stats").must_exist.with(:minute, '*/2').and(:command, "/etc/ganglia/scripts/memcached > /dev/null 2>&1")
  end
end
