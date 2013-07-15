require 'minitest/spec'

describe_recipe 'opsworks_nodejs::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'deletes downloaded packages' do
    case node[:platform]
    when'debian','ubuntu'
      file(File.join('/tmp', node[:opsworks_nodejs][:deb])).wont_exist
    when 'centos','redhat','fedora','amazon'
      file(File.join('/tmp', node[:opsworks_nodejs][:rpm])).wont_exist
    end
  end

  it 'access the right node executable from the default path' do
     (`which node`).chomp.must_equal("/usr/local/bin/node")
  end

  it 'installs nodejs on user space' do
    file("/usr/local/bin/node").must_exist
  end

  it 'installs the expected version of nodejs' do
     (`/usr/local/bin/node --version`).chomp.must_match(/#{node[:opsworks_nodejs][:version]}/)
  end

  it 'access the right npm executable from the default path' do
     (`which npm`).chomp.must_equal("/usr/local/bin/npm")
  end

  it 'installs npm' do
    file("/usr/local/bin/npm").must_exist
  end

end
