package 'socat'

cookbook_file "/etc/ganglia/scripts/haproxy" do
  source "haproxy.rb"
  mode "0755"
end

cron "Ganglia HAProxy" do
  minute "*/1"
  command "/etc/ganglia/scripts/haproxy > /dev/null 2>&1"
end