require 'minitest/spec'

describe_recipe 'mod_php5_apache2::php' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
