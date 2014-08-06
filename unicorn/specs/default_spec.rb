require 'minitest/spec'

describe_recipe 'unicorn::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'installs unicorn' do
    assert system("#{node[:dependencies][:gem_binary]} list | grep unicorn | grep '#{node[:unicorn][:version]}'")
  end
end
