require 'minitest/spec'

describe_recipe 'opsworks_ganglia::monitor-haproxy' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'installs socat' do
    package('socat').must_be_installed
  end

  it 'creates haproxy monitor script' do
    file('/etc/ganglia/scripts/haproxy').must_exist.with(:mode, '755')
  end

  it 'creates haproxy monitor cron' do
    cron("Ganglia HAProxy").must_exist.with(:minute, '*/1').and(:command, '/etc/ganglia/scripts/haproxy > /dev/null 2>&1')
  end
end
