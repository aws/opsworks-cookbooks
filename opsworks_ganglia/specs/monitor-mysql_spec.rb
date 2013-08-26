require 'minitest/spec'

describe_recipe 'opsworks_ganglia::monitor-mysql' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'installs dependencies' do
    case node["platform_family"]
    when "rhel"
      package("MySQL-python").must_be_installed
    when "debian"
      package("python-mysqldb").must_be_installed
    end
  end

  it 'creates mysql pyconf' do
    file('/etc/ganglia/conf.d/mysql.pyconf').must_exist.with(:owner, 'root').and(:group, 'root').and(:mode, '644')
  end

  it 'creates mysql.py module' do
    file('/etc/ganglia/python_modules/mysql.py').must_exist.with(:mode, '644')
  end

  it 'creates DBUtil.py module' do
    file('/etc/ganglia/python_modules/DBUtil.py').must_exist.with(:mode, '644')
  end
end
