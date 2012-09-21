require 'minitest/spec'

describe_recipe 'scalarium_initial_setup::setup_rhel_repos' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

end
