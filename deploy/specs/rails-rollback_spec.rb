require 'minitest/spec'

describe_recipe 'deploy::rails-rollback' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
