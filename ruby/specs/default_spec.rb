require 'minitest/spec'

describe_recipe 'ruby::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'uninstalls ruby-enterprise' do
    package('ruby-enterprise').wont_be_installed
  end

  it 'installs ruby' do
    file('/usr/local/bin/ruby').must_exist
  end

  it 'must be the right version' do
    ruby_version_pattern = %r(#{node['ruby']['version'].sub('-p', '-?p')})
    assert_match ruby_version_pattern, `/usr/local/bin/ruby -v`.chomp
  end
end
