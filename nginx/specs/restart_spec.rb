require 'minitest/spec'

describe_recipe 'nginx::restart' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'restarts nginx' do
    service('nginx').must_be_running
  end
end
