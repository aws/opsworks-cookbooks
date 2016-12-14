require 'minitest/spec'

describe_recipe 'puma::stop' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
