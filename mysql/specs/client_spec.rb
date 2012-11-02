require 'minitest/spec'

describe_recipe 'mysql::client' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'installs packages for client' do
    case node[:platform]
    when 'centos','redhat','fedora','amazon'
      package('mysql-devel').must_be_installed
      package('mysql').must_be_installed
    when 'debian','ubuntu'
      package('libmysqlclient-dev').must_be_installed
      package('mysql-client').must_be_installed
    end
  end
end
