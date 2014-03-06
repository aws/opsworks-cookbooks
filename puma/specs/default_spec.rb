require 'minitest/spec'

describe_recipe 'puma::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'installs puma' do
    assert system("#{node[:dependencies][:gem_binary]} list | grep puma | grep '#{node[:puma][:version]}'")
  end
end
