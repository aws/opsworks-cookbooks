require 'minitest/spec'

describe_recipe 'opsworks_ganglia::bind-mount-data' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'creates rrds folder for bind mounting' do
    directory(File.join(node[:ganglia][:datadir], 'rrds')).must_exist.with(:mode, '775')
  end

  it 'should cover the data directory by an autofs map' do
    assert system("automount -m | grep '#{node[:ganglia][:original_datadir]} | -fstype=none,bind,rw :#{node[:ganglia][:datadir]}'")
  end
end
