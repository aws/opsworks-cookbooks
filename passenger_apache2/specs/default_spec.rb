require 'minitest/spec'

describe_recipe 'passenger_apache2::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
