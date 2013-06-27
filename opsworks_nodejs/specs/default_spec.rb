require 'minitest/spec'

describe_recipe 'opsworks_nodejs::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  describe 'debian based systems' do
    it 'grabs deb file' do
      skip unless ['debian','ubuntu'].include?(node[:platform])
      file(File.join('/tmp', node[:opsworks_nodejs][:deb])).must_exist
    end
  end

  describe 'rhel based systems' do
    it 'grabs rpm file' do
      skip unless ['centos','redhat','fedora','amazon'].include?(node[:platform])
      file(File.join('/tmp', node[:opsworks_nodejs][:rpm])).must_exist
    end
  end

  it 'installs nodejs pkg' do
     (`node --version`).chomp.must_equal("v#{node[:opsworks_nodejs][:version]}")
  end
end
