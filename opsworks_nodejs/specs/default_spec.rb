require 'minitest/spec'

describe_recipe 'opsworks_nodejs::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  describe 'delete downloaded packages' do
    it 'deletes it them on deb-based systems' do
      skip unless ['debian','ubuntu'].include?(node[:platform])
      file(File.join('/tmp', node[:opsworks_nodejs][:deb])).wont_exist
    end

    it 'deletes them on rpm-based systems' do
      skip unless ['centos','redhat','fedora','amazon'].include?(node[:platform])
      file(File.join('/tmp', node[:opsworks_nodejs][:rpm])).wont_exist
    end
  end

  it 'installs nodejs on user space' do
    file("/usr/local/bin/node").must_exist
  end

  it 'access the right node executable from the default path' do
     (`which node`).chomp.must_equal("/usr/local/bin/node")
  end

  it 'installs the expected version of nodejs' do
     (`/usr/local/bin/node --version`).chomp.must_equal("v#{node[:opsworks_nodejs][:version]}")
  end

  it 'installs npm' do
    file("/usr/local/bin/npm").must_exist
  end

end
