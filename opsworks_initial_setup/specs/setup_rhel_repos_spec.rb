require 'minitest/spec'

describe_recipe 'opsworks_initial_setup::setup_rhel_repos' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'installs EPEL repo' do
    skip unless node[:platform] == 'amazon'
    assert system("yum-config-manager epel | grep 'enabled = True'")
  end
end
