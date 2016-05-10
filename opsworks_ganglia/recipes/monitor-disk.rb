package "bc" do
  retries 3
  retry_delay 5
end

disks = `mount | grep -E '/dev/sd|/dev/xvd' | awk '{print $1}'`.split("\n")

if node[:ebs] && node[:ebs][:devices]
  Chef::Log.info("Adding EBS volumes #{node[:ebs][:devices].keys.inspect} to monitoring")
  disks = disks + node[:ebs][:devices].keys
end

disks = disks.flatten.map{|d| d.sub('/dev/', '').sub(/(xvd.)(.*)/, '\1p\2')}.uniq

disks.each do |device_id|
  Chef::Log.info("Installing Monitoring for disk #{device_id}")
  
  template "/etc/ganglia/scripts/diskstats-#{device_id}" do
    source "diskstats.sh.erb"
    owner "root"
    group "root"
    mode '0744'
    variables :disk => device_id
  end

  cron "Ganglia Disk stats for #{device_id}" do
    minute "*/2"
    command "/etc/ganglia/scripts/diskstats-#{device_id} > /dev/null 2>&1"
  end
end
