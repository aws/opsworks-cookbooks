require 'minitest/spec'

describe_recipe 'deploy::rails' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
