require 'minitest/spec'

describe_recipe 'ruby::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  context 'debian systems', :if => platform?('debian','ubuntu') do
    it 'creates deb file' do
      file(File.join('/tmp', node[:ruby][:deb])).must_exist
    end

    it 'uninstalls ruby-enterprise' do
      package('ruby-enterprise').wont_be_installed
    end
  end

  context 'rhel based systems', :if => platform?('centos','redhat','amazon') do
    it 'creates rpm file' do
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
