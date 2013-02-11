cookbook_file "/etc/ganglia/scripts/fd-and-sockets" do
  source "fd-and-sockets.sh"
  mode "0755"
end

cron "Ganglia File Descriptors and Sockets in use" do
  minute "*/2"
  command "/etc/ganglia/scripts/fd-and-sockets > /dev/null 2>&1"
end