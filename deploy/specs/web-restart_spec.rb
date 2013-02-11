require 'minitest/spec'

describe_recipe 'deploy::web-restart' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'starts nginx' do
    service("nginx").must_be_running
  end
end
