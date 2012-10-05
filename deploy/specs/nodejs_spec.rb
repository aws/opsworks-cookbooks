require 'minitest/spec'

describe_recipe 'deploy::nodejs' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  # This ensures that we actually have the monit file in the right place -
  # this bit in the Chef cookbook can fail silently if we throw the
  # file where we don't expect it on a different OS.
  it 'ensures monit is actually monitoring the service' do
    node[:deploy].each do |app, deploy|
      if deploy[:application_type] == 'nodejs'
        assert system("monit status | grep node_web_app_#{app}")
      end
    end
  end
end
