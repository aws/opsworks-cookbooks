require 'minitest/spec'

describe_recipe 'ebs::volumes' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'creates mount point directory' do
    node[:ebs][:devices].each do |device, options|
      directory(options[:mount_point]).must_exist.with(:mode, '755')
    end
  end

  it 'mounts the volume' do
    node[:ebs][:devices].each do |device, options|
      mount(options[:mount_point], :device => device).must_be_mounted.with(
        :fstype, options[:fstype])
    end
  end
end
