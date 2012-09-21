require 'minitest/spec'

describe_recipe 'deploy::php-undeploy' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
