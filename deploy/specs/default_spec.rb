require 'minitest/spec'

describe_recipe 'deploy::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'creates users defined for each application with the right information' do
    node[:deploy].each do |application, deploy|
      user(deploy[:user]).must_exist
      if deploy[:user] == "root"
        user(deploy[:user]).must_have(:home, "/root")
        user(deploy[:user]).must_have(:comment, "root")
      else
        user(deploy[:user]).must_have(:home, deploy[:home])
        user(deploy[:user]).must_have(:comment, "deploy user")
      end
      user(deploy[:user]).must_have(:shell, deploy[:shell])

      # NOTE: Why doesn't this work?
      # Because :gid compares against the numerical GID, not the
      # group name. So we'll have to grep against the group name
      # on /etc/group and see if we get anything back.

      # BAD:
      #user(deploy[:user]).must_have(:gid, deploy[:group])
      # GOOD:
      assert system("grep '^#{deploy[:group]}:' /etc/group")
    end
  end
end
