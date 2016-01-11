Chef::Log.info("Creating the cloudwatch folder")
directory "/opt/aws/cloudwatch" do
  recursive true
end
Chef::Log.info("Creating the .aws folder to receive the credentials")
directory "/root/.aws" do
  recursive true
end

Chef::Log.info("Downloading the cloudwatch agent")
remote_file "/opt/aws/cloudwatch/awslogs-agent-setup.py" do
  source "https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py"
  mode "0755"
end

Chef::Log.info("Installing the CloudWatch agent using the custom config file")
execute "Install CloudWatch Logs agent" do
  command "/opt/aws/cloudwatch/awslogs-agent-setup.py -n -r us-east-1 -c /tmp/cwlogs.cfg"
  not_if { system "pgrep -f aws-logs-agent-setup" }
end

Chef::Log.info("Adding the credentials to access the CloudWatch")
template "/root/.aws/credentials" do
  cookbook "awslogs"
  source "credentials.erb"
  owner "root"
  group "root"
  mode 0600
  variables(:aws_access_key_id => node[:aws_access_key_id], :aws_secret_access_key => node[:aws_secret_access_key] )
end

service node[:cwlogs][:service_name] do
  action [:enable, :restart]
end
