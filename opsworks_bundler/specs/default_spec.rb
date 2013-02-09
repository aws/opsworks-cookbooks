require 'minitest/spec'

describe_recipe 'opsworks_bundler::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'installs bundler gem' do
    skip unless node[:opsworks_bundler][:manage_package]
    assert system("#{node[:dependencies][:gem_binary]} list | grep bundler | grep #{node[:opsworks_bundler][:version]}")
  end
end
