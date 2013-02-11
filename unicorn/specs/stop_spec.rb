require 'minitest/spec'

describe_recipe 'unicorn::stop' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
