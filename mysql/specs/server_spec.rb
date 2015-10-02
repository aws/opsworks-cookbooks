require 'minitest/spec'

describe_recipe 'mysql::server' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions


  describe 'init script on ubuntu machines < 10.04' do
    it 'creates a patch file for the init script' do
      skip unless node[:platform] == 'ubuntu' && node[:platform_version].to_f < 10.04
      file('/tmp/mysql_init.patch').must_exist
    end

    it 'fixes the init script with the patch' do
      skip unless node[:platform] == 'ubuntu' && node[:platform_version].to_f < 10.04
      file('/etc/init.d/mysql').must_include 'sleep $i'
    end
  end

  it "starts the mysql service" do
    mysql_name = node[:mysql][:name] || "mysql"
    case node[:platform]
    when "redhat", "centos", "fedora", "amazon"
      service("#{mysql_name}d").must_be_running
    else
      service("mysql").must_be_running
    end
  end

  it 'enables the mysql service' do
    mysql_name = node[:mysql][:name] || "mysql"
    case node[:platform]
    when 'debian','ubuntu'
      #service('mysql').must_be_enabled
      # ugly but works, as opposite to the above one
      file('/etc/init/mysql.conf').must_match /^start on/
    when 'centos','redhat','fedora','amazon'
      service("#{mysql_name}d").must_be_enabled
    end
  end
end
