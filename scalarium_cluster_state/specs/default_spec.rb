require 'minitest/spec'

describe_recipe 'scalarium_cluster_state::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
