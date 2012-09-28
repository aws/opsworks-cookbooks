require 'minitest/spec'

describe_recipe 'scalarium_nodejs::npm' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'grabs tarball' do
    file(File.join('/tmp', "npm-#{node[:scalarium_nodejs][:npm_version]}.tgz")).must_exist
  end

  it 'installs npm' do
    file("/usr/local/bin/npm").must_exist
  end

  it 'ensures npm is the right version' do
    assert system("/usr/local/bin/npm -v | grep -q '#{node[:scalarium_nodejs][:npm_version]}'")
  end
end
