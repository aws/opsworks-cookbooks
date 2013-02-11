require 'minitest/spec'

describe_recipe 'deploy::nodejs-restart' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
