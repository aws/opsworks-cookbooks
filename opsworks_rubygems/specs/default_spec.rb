require 'minitest/spec'

describe_recipe 'opsworks_rubygems::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'Cleans up downloaded and generated data' do
   file("/tmp/rubygems-#{node[:opsworks_rubygems][:version]}.tar.gz").wont_exist
   file("/tmp/rubygems-#{node[:opsworks_rubygems][:version]}").wont_exist
  end

  it 'Installs rubygems' do
    file('/usr/local/bin/gem').must_exist
  end

  it 'Ensures the right version of rubygems was installed' do
    assert_equal node[:opsworks_rubygems][:version], `/usr/local/bin/gem -v`.chomp
  end
end
