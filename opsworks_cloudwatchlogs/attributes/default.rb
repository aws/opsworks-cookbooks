if node["platform"] == "amazon"
  default["cloudwatchlogs"]["config_file"] = "/etc/awslogs/awslogs.conf" # Configures the logs for the agent to ship
  default["cloudwatchlogs"]["home_dir"] = "/etc/awslogs" # Contains configuration files
  default["cloudwatchlogs"]["state_file"] = "/var/lib/awslogs/agent-state" # See http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/QuickStartChef.html
else
  default["cloudwatchlogs"]["config_file"] = "/opt/aws/cloudwatch/cwlogs.cfg" # Configures the logs to ship, used by installation script
  default["cloudwatchlogs"]["home_dir"] = "/var/awslogs" # Contains the awslogs package
  default["cloudwatchlogs"]["state_file"] = "/var/awslogs/state/agent-state" # See http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/QuickStartChef.html
end

default["cloudwatchlogs"]["AGENT_LOGS"] = "/var/log/aws/opsworks/*.log"
default["cloudwatchlogs"]["CHEF_LOGS"] = "/var/lib/aws/opsworks/chef/*.log"
