require 'minitest/spec'

describe_recipe 'mysql::server' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  context 'init script on ubuntu machines < 10.04', :if => node[:platform] == 'ubuntu' && node[:platform_version].to_f < 10.04 do
    it 'creates a patch file for the init script' do
      file('/tmp/mysql_init.patch').must_exist
    end

    it 'fixes the init script with the patch' do
      file('/etc/init.d/mysql').must_include 'sleep $i'
    end
  end

  it 'starts the mysql service' do
    case node[:platform]
    when 'debian','ubuntu'
      service('mysql').must_be_running
    when 'centos','amazon','fedora','redhat','scientific','oracle'
      service('mysqld').must_be_running
    end
  end

  it 'starts the mysql service' do
    case node[:platform] 
    when 'debian','ubuntu'
      service('mysql').must_be_enabled
    when 'centos','amazon','fedora','redhat','scientific','oracle'
      service('mysqld').must_be_enabled
    end
  end
end
