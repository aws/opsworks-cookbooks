require 'minitest/spec'

describe_recipe 'nginx::stop' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'stops nginx' do
    service('nginx').wont_be_running
  end
end
