require 'minitest/spec'

describe_recipe 'opsworks_ganglia::monitor-fd-and-sockets' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'creates fd-and-sockets monitor' do
    file('/etc/ganglia/scripts/fd-and-sockets').must_exist.with(:mode, '755')
  end

  it 'creates fd-and-sockets cron' do
    cron(
      "Ganglia File Descriptors and Sockets in use"
    ).must_exist.with(:minute, '*/2').and(:command, "/etc/ganglia/scripts/fd-and-sockets > /dev/null 2>&1")
  end
end
