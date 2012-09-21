require 'minitest/spec'

describe_recipe 'ebs::volumes' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
