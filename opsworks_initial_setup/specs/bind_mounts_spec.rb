require 'minitest/spec'

describe_recipe 'opsworks_initial_setup::bind_mounts' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'creates directories for bind mount' do
    skip unless node[:platform] == 'amazon'
    node[:opsworks_initial_setup][:bind_mounts][:mounts].each do |dir, source|
      directory(dir).must_exist.with(:mode, '755')
      directory(source).must_exist.with(:mode, '755')
    end
  end

  it 'should cover the bind mounts by an autofs map' do
    node[:opsworks_initial_setup][:bind_mounts][:mounts].each do |dir, source|
      assert system("automount -m | grep '#{dir} | -fstype=none,bind,rw :#{source}'")
    end
  end
end
