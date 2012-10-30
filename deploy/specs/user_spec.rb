require 'minitest/spec'

describe_recipe 'deploy::user' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  # This recipe is deprecated
end
