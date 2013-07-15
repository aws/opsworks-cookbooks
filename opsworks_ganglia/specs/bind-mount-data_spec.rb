require 'minitest/spec'

describe_recipe 'opsworks_ganglia::bind-mount-data' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'creates rrds folder for bind mounting' do
    directory(::File.join(node[:ganglia][:datadir], 'rrds')).must_exist.with(:mode, '775')
  end

  it 'should cover the data directory by an autofs map' do
    (`automount -m`).must_include(
      "#{node[:ganglia][:original_datadir]} | #{node[:ganglia][:autofs_options]} :#{node[:ganglia][:datadir]}"
    )
  end
end
