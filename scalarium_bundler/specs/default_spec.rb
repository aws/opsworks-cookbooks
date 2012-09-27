require 'minitest/spec'

describe_recipe 'scalarium_bundler::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'installs bundler gem' do
    skip unless node[:scalarium_bundler][:manage_package]
    assert system("#{node[:dependencies][:gem_binary]} list | grep bundler | grep #{node[:scalarium_bundler][:version]}")
  end
end
