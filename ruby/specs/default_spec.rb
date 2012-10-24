require 'minitest/spec'

describe_recipe 'ruby::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  describe 'debian systems' do
    it 'creates deb file' do
      skip unless ['debian','ubuntu'].include?(node[:platform])
      file(File.join('/tmp', node[:ruby][:deb])).must_exist
    end

    it 'uninstalls ruby-enterprise' do
      skip unless ['debian','ubuntu'].include?(node[:platform])
      package('ruby-enterprise').wont_be_installed
    end
  end

  describe 'rhel based systems' do
    it 'creates rpm file' do
      skip unless ['centos','redhat','amazon'].include?(node[:platform])
      file(File.join('/tmp', node[:ruby][:rpm])).must_exist
    end
  end

  it 'installs ruby' do
    file('/usr/local/bin/ruby').must_exist
  end

  it 'must be the right version' do
    assert system("/usr/local/bin/ruby -v | grep -q '#{node[:ruby][:version]}'")
  end
end
