service "awslogs" do
  action :stop
end

directory node["cloudwatchlogs"]["home_dir"] do
  action :delete
  recursive true
end

if platform?("amazon")
  package "awslogs" do
    action :remove
  end
else
  directory "/opt/aws/cloudwatch" do
    action :delete
    recursive true
  end

  file "/etc/init.d/awslogs" do
    action :delete
  end
end
