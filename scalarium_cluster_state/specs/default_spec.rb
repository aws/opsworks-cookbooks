require 'minitest/spec'

describe_recipe 'scalarium_cluster_state::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'creates cluster state directory' do
    directory(File.dirname(node[:scalarium][:stack_state][:path])).must_exist.with(:mode, '755')
  end

  it 'creates cluster_state.json' do
    file(node[:scalarium][:stack_state][:path]).must_exist.with(:mode, '644')
  end

  it 'creates /etc/hosts' do
    file('/etc/hosts').must_exist.with(:mode, '644')
  end
end
