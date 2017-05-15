[node["cloudwatchlogs"]["home_dir"], node["cloudwatchlogs"]["state_file_dir"]].each do |dir|
  directory dir do
    recursive true
  end
end

template node["cloudwatchlogs"]["config_file"] do
  source "awslogs.conf.erb"
  variables({
    :state_file_dir => node["cloudwatchlogs"]["state_file_dir"],
    :log_streams => node["cloudwatchlogs"]["log_streams"]
  })
  owner "root"
  group "root"
  mode 0644
end

remote_file "/opt/aws/cloudwatch/awslogs-agent-setup.py" do
  source "https://aws-cloudwatch.s3.amazonaws.com/downloads/latest/awslogs-agent-setup.py"
  mode 0700
  retries 3
  retry_delay 5
end

package "python" do
  retries 3
  retry_delay 5
end

execute "Install CloudWatch Logs agent" do
  command "/opt/aws/cloudwatch/awslogs-agent-setup.py -n -r '#{node['opsworks']['instance']['region']}' -c '#{node['cloudwatchlogs']['config_file']}'"
  creates File.join(node["cloudwatchlogs"]["state_file_dir"], "state_file")
end

file File.join(node["cloudwatchlogs"]["home_dir"], "INSTALLED_BY_OPSWORKS") do
  content "CloudWatch Logs agent was installed by OpsWorks. Do not delete this file."
end

service "awslogs" do
  supports :status => true, :restart => true
  action [:enable, :start]
end
