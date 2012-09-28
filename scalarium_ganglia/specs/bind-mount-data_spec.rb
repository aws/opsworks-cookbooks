require 'minitest/spec'

describe_recipe 'scalarium_ganglia::bind-mount-data' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'creates rrds folder for bind mounting' do
    directory(File.join(node[:ganglia][:datadir], 'rrds')).must_exist.with(:mode, '775')
  end

  it 'creates mounts to the data directory' do
    mount(node[:ganglia][:original_datadir], :device => node[:ganglia][:datadir]).must_be_mounted
    mount(node[:ganglia][:original_datadir], :device => node[:ganglia][:datadir]).must_be_enabled.with(:fstype, 'none').and(:options, 'bind,rw')
  end
end
