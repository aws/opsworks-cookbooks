require 'minitest/spec'

describe_recipe 'opsworks_ganglia::monitor-passenger' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'creates passenger-memory-stats ruby script' do
    file('/etc/ganglia/scripts/passenger-memory-stats').must_exist.with(:mode, '755')
  end

  it 'creates passenger-status ruby script' do
    file('/etc/ganglia/scripts/passenger-status').must_exist.with(:mode, '755')
  end

  it 'creates passenger-memory-stats cron' do
    cron(
      "Ganglia Passenger Memory"
    ).must_exist.with(:minute, '*/2').and(:command, "/etc/ganglia/scripts/passenger-memory-stats > /dev/null 2>&1")
  end

  it 'creates passenger-status cron' do
    cron(
      "Ganglia Passenger Status"
    ).must_exist.with(:minute, '*/2').and(:command, "/etc/ganglia/scripts/passenger-status > /dev/null 2>&1")
  end
end
