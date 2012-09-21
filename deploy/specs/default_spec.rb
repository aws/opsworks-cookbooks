require 'minitest/spec'

describe_recipe 'deploy::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'creates users defined for each application with the right information' do
    node[:deploy].each do |application, deploy|
      user(deploy[:user]).must_exist
      user(deploy[:user]).must_have(:home, deploy[:home])
      user(deploy[:user]).must_have(:shell, deploy[:shell])
      user(deploy[:user]).must_have(:comment, "deploy user")
      user(deploy[:user]).must_have(:gid, deploy[:group])
    end
  end
end
