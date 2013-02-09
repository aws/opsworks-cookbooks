require 'minitest/spec'

describe_recipe 'opsworks_initial_setup::sqlite' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'installs sqlite' do
    skip unless %w{centos amazon redhat scientific fedora oracle}.include?(node[:platform])
    package('sqlite-devel').must_be_installed
  end
end
