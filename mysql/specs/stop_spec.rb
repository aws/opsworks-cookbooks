require 'minitest/spec'

describe_recipe 'mysql::stop' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'should stop the mysql service' do
    case node[:platform]
    when 'debian','ubuntu'
      service('mysql').wont_be_running
    when 'centos','redhat','fedora','amazon'
      service('mysqld').wont_be_running
    end
  end
end
