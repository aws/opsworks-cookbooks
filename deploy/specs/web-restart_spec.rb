require 'minitest/spec'

describe_recipe 'deploy::web-restart' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
