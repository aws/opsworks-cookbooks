def is_amazon_linux_2?
  os_release = "/etc/os-release"
  if File.exist?(os_release)
    os_contents = File.open(os_release).readlines
    os_name = os_contents.find { |line| line.start_with? "PRETTY_NAME" }.chomp
    if os_name && os_name.match(/"(.*)"/)[1] == "Amazon Linux 2"
      return true
    end
  end

  false
end

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

# For Amazon Linux we need to look for "Amazon Linux AMI" in order to install CWLogs Agent correctly
# in order to do this we copy the original contents of /etc/issue to a temporary location and then
# copy the original contents back post CWLogs Agent installation
if is_amazon_linux_2?
  remote_file "Create copy of issue file" do
    source "file:///etc/issue"
    path "/tmp/issue.copy"
    mode '644'
    owner 'root'
    group 'root'
  end

  file "/etc/issue" do
    content 'Amazon Linux AMI'
    mode '644'
    owner 'root'
    group 'root'
  end
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

# Copy over original /etc/issue contents in the case of Amazon Linux
if is_amazon_linux_2?
  remote_file "Copy back original issue file" do
    source "file:///tmp/issue.copy"
    path "/etc/issue"
    mode '644'
    owner 'root'
    group 'root'
  end
end
