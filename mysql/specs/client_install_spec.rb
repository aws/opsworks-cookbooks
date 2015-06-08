require 'minitest/spec'

describe_recipe 'mysql::client' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions


  it 'installs packages for client' do
    db_provider = node[:mysql][:provider] || "mysql"
    if node[:opsworks][:layers].has_key?('db-master')
      case node[:platform]
      when 'centos','redhat','fedora','amazon'
        package("#{db_provider}-devel").must_be_installed
        package(db_provider).must_be_installed
      when 'debian','ubuntu'
        package('libmysqlclient-dev').must_be_installed
        package('mysql-client').must_be_installed
      end
    end
  end
end
