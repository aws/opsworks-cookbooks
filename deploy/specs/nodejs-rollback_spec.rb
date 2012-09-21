require 'minitest/spec'

describe_recipe 'deploy::nodejs-rollback' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
