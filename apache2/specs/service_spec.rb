require 'minitest/spec'

describe_recipe 'apache2::service' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
