require 'minitest/spec'

describe_recipe 'passenger_apache2::mod_rails' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
