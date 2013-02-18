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

  it 'creates mounts for directories' do
    node[:opsworks_initial_setup][:bind_mounts][:mounts].each do |dir, source|
      mount(dir, :device => source).must_be_mounted
      mount(dir, :device => source).must_be_enabled.with(:fstype, 'none').and(:options, ['bind', 'rw'])
    end
  end
end
