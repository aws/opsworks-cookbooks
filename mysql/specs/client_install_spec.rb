require 'minitest/spec'

describe_recipe 'mysql::client' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions


  it 'installs packages for client' do
    mysql_name = node[:mysql][:name] || "mysql"
    if node[:opsworks][:layers].has_key?('db-master')
      case node[:platform]
      when 'centos','redhat','fedora','amazon'
        if rhel7?
          package("mariadb-devel").must_be_installed
        else
          package("#{mysql_name}-devel").must_be_installed
        end
        package(mysql_name).must_be_installed
      when 'debian','ubuntu'
        package('libmysqlclient-dev').must_be_installed
        package('mysql-client').must_be_installed
      end
    end
  end
end
