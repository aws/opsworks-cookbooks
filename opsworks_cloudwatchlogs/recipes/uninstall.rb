service "awslogs" do
  action :stop
end

[node["cloudwatchlogs"]["home_dir"], node["cloudwatchlogs"]["state_file_dir"]].each do |dir|
  directory dir do
    action :delete
    recursive true
  end
end

file "/etc/init.d/awslogs" do
  action :delete
end
