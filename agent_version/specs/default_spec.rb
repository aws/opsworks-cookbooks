require 'minitest/spec'

describe_recipe 'agent_version::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'should write the file with the correct permissions' do
    file("#{node[:scalarium][:agent][:base_dir]}/TARGET_VERSION").must_exist.with(:mode, '600').and(
         :owner, "#{node[:scalarium][:agent][:user]}").and(:group, "#{node[:scalarium][:agent][:group]}")
  end

  it 'should have the correct version in the file' do
    file("#{node[:scalarium][:agent][:base_dir]}/TARGET_VERSION").must_include node.scalarium.agent_version
  end
end
