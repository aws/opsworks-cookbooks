package "socat" do
  retries 3
  retry_delay 5
end

template "/etc/ganglia/scripts/haproxy" do
  source "haproxy.rb.erb"
  mode "0755"
end

cron "Ganglia HAProxy" do
  minute "*/1"
  command "/etc/ganglia/scripts/haproxy > /dev/null 2>&1"
end
