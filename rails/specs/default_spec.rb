require 'minitest/spec'

describe_recipe 'rails::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
