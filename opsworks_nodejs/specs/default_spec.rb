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

  it 'installs nodejs pkg' do
     (`node --version`).chomp.must_equal("v#{node[:opsworks_nodejs][:version]}")
  end
end
