require 'minitest/spec'

describe_recipe 'mysql::percona_repository' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'creates temporary directory' do
    directory(node[:percona][:tmp_dir]).must_exist
  end

  it 'downloads percona xtradb' do
    file("#{node[:percona][:tmp_dir]}/#{node[:scalarium][:instance][:architecture]}.tar.bzip2").must_exist
  end

  it 'extracts percona xtradb' do
    directory("#{node[:percona][:tmp_dir]}/#{node[:scalarium][:instance][:architecture]}").must_exist
  end
end
