require 'minitest/spec'

describe_recipe 'mysql::stop' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions


  it 'should stop the mysql service' do
    db_provider = node[:mysql][:provider] || "mysql"
    case node[:platform]
    when 'debian','ubuntu'
      service('mysql').wont_be_running
    when 'centos','redhat','fedora','amazon'
      if db_provider == "mysql"
        service("mysqld").wont_be_running
      elsif db_provider == "mariadb"
        service("mariadb").wont_be_running
      else
        fail "Invalid provider for mysql"
      end
    end
  end
end
