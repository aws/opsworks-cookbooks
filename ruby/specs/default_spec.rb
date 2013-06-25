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
    assert_match node['ruby']['version'], `/usr/local/bin/ruby -v`.chomp
  end
end
