directory node["cloudwatchlogs"]["home_dir"] do
  recursive true
end

template node["cloudwatchlogs"]["config_file"] do
  source "awslogs.conf.erb"
  variables({
    :state_file => node["cloudwatchlogs"]["state_file"],
    :cloudwatchlogs => node["opsworks"]["cloud_watch_logs_configurations"],
    :hostname => node["opsworks"]["instance"]["hostname"]
  })
  owner "root"
  group "root"
  mode 0644
end

if platform?("amazon")
  package "awslogs" do
    retries 3
    retry_delay 5
  end

  template "#{node['cloudwatchlogs']['home_dir']}/awscli.conf" do
    source "awscli.conf.erb"
    variables :region => node["opsworks"]["instance"]["region"]
  end
else
  directory "/opt/aws/cloudwatch" do
    recursive true
  end

  remote_file "/opt/aws/cloudwatch/awslogs-agent-setup.py" do
    source "https://aws-cloudwatch.s3.amazonaws.com/downloads/latest/awslogs-agent-setup.py"
    mode 0700
    retries 3
  end

  package "python" do
    retries 3
    retry_delay 5
  end

  execute "Install CloudWatch Logs agent" do
    command "/opt/aws/cloudwatch/awslogs-agent-setup.py -n -r '#{node['opsworks']['instance']['region']}' -c '#{node['cloudwatchlogs']['config_file']}'"
    not_if { File.exists?(node["cloudwatchlogs"]["state_file"]) }
  end
end

service "awslogs" do
  supports :status => true, :restart => true
  action [:enable, :start]
end
