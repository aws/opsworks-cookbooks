remote_file "/etc/ganglia/scripts/passenger-memory-stats" do
  source "passenger_memory_stats.rb"
  mode "0755"
end

remote_file "/etc/ganglia/scripts/passenger-status" do
  source "passenger_status.rb"
  mode "0755"
end

cron "Ganglia Passenger Memory" do
  minute "*/2"
  command "/etc/ganglia/scripts/passenger-memory-stats"
end

cron "Ganglia Passenger Status" do
  minute "*/2"
  command "/etc/ganglia/scripts/passenger-status"
end
