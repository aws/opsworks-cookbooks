require 'minitest/spec'

describe_recipe 'mysql::percona_server' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
