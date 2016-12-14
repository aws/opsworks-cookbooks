require 'minitest/spec'

describe_recipe 'puma::rails' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
