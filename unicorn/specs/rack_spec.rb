require 'minitest/spec'

describe_recipe 'unicorn::rack' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
