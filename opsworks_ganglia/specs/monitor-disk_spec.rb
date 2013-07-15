require 'minitest/spec'

describe_recipe 'opsworks_ganglia::monitor-disk' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'installs bc' do
    package('bc').must_be_installed
  end

  it 'creates scripts for each disk along with cron entries' do
    # Let's see - we'll go ahead and try to reproduce what disks we
    # want to monitor, but through another method - /etc/mtab.
    # If we get the same results, yay! And we should get the same
    # results...
    mtab = IO.read('/etc/mtab').split("\n")
    disks = mtab.grep(/\/dev\/sd|\/dev\/xvd/).map { |x| x.split(' ').first }
    if node[:ebs] && node[:ebs][:devices]
      disks = disks + node[:ebs][:devices].keys
    end

    disks = disks.flatten.map { |x| x.sub('/dev/', '').sub(/(xvd.)(.*)/, '\1p\2')}.uniq

    disks.each do |device_id|
      file(File.join('/etc/ganglia/scripts', "diskstats-#{device_id}")).must_include device_id

      file(
        File.join('/etc/ganglia/scripts', "diskstats-#{device_id}")
      ).must_exist.with(:owner, 'root').and(:group, 'root').and(:mode, '744')

      cron(
        "Ganglia Disk stats for #{device_id}"
      ).must_exist.with(:minute, '*/2').and(:command, "/etc/ganglia/scripts/diskstats-#{device_id} > /dev/null 2>&1")
    end
  end
end
