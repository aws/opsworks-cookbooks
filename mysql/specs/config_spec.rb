require 'minitest/spec'

describe_recipe 'mysql::config' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'installs config file' do
    case node[:platform]
    when 'debian','ubuntu'
      file('/etc/mysql/my.cnf').must_exist.with(:mode, '644').and(
        :owner, 'root').and(:group, 'root')
    when 'centos','redhat','fedora','amazon'
      file('/etc/my.cnf').must_exist.with(:mode, '644').and(
        :owner, 'root').and(:group, 'root')
    end
  end

  it 'should still have mysql running after my.cnf installation' do
    mysql_name = node[:mysql][:name] || "mysql"
    case node[:platform]
    when "redhat", "centos", "fedora", "amazon"
      service("#{mysql_name}d").must_be_running
    else
      service("mysql").must_be_running
    end
  end
end
