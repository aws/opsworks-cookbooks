require 'minitest/spec'

describe_recipe 'deploy::nodejs-undeploy' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
