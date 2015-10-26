require 'minitest/spec'

describe_recipe 'mysql::stop' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions


  it 'should stop the mysql service' do
    mysql_name = node[:mysql][:name] || "mysql"
    case node[:platform]
    when "redhat", "centos", "fedora", "amazon"
      service("#{mysql_name}d").wont_be_running
    else
      service("mysql").wont_be_running
    end
  end
end
