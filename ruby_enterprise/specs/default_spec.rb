require 'minitest/spec'

describe_recipe 'ruby_enterprise::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  describe 'debian based machines' do
    it 'removes ruby1.9' do
      skip unless ['debian','ubuntu'].include?(node[:platform])
      package('ruby1.9').wont_be_installed
    end

    it 'creates deb file' do
      skip unless ['debian','ubuntu'].include?(node[:platform])
      arch = RUBY_PLATFORM.match(/64/) ? 'amd64' : 'i386'
      file("/tmp/#{File.basename(node[:ruby_enterprise][:url][arch])}").must_exist
    end

    it 'installs libssl0.9.8 if we are using specific ubuntu versions' do
      skip unless node[:platform].eql?('ubuntu') && ['11.10', '12.04'].include?("#{node[:platform_version]}")
      package('libssl0.9.8').must_be_installed
    end
  end

  describe 'redhat based machines' do
    it 'creates rpm file' do
      skip unless ['centos','amazon','redhat','fedora','scientific','oracle'].include?(node[:platform])
      arch = node[:kernel][:machine]
      file("/tmp/#{File.basename(node[:ruby_enterprise][:url][arch])}").must_exist
    end

    it 'removes ruby19' do
      skip unless ['centos','amazon','redhat','fedora','scientific','oracle'].include?(node[:platform])
      package('ruby19').wont_be_installed
    end
  end

  it 'installs ruby enterprise edition' do
    package('ruby-enterprise').must_be_installed
  end
end
