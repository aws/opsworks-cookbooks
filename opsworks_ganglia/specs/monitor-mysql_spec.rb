require 'minitest/spec'

describe_recipe 'opsworks_ganglia::monitor-mysql' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'installs deps' do
    case node[:platform]
    when "centos","redhat","fedora","scientific","amazon","oracle"
      package("MySQL-python").must_be_installed
    when "debian","ubuntu"
      package("python-mysqldb").must_be_installed
    end
  end

  it 'creates mysql pyconf' do
    file('/etc/ganglia/conf.d/mysql.pyconf').must_exist.with(:owner, 'root').and(:group, 'root').and(:mode, '644')
  end
end
