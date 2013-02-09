require 'minitest/spec'

describe_recipe 'opsworks_rubygems::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'installs rubygems' do
    file('/usr/local/bin/gem').must_exist
  end

  it 'ensures rubygems is the right version' do
    assert system("/usr/local/bin/gem -v | grep '#{node[:opsworks_rubygems][:version]}'")
  end
end
