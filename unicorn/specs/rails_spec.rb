require 'minitest/spec'

describe_recipe 'unicorn::rails' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
