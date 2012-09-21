require 'minitest/spec'

describe_recipe 'mod_php5_apache2::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
