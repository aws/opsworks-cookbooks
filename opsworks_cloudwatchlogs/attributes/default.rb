default["cloudwatchlogs"]["config_file"] = "/opt/aws/cloudwatch/cwlogs.cfg"
default["cloudwatchlogs"]["home_dir"] = "/opt/aws/cloudwatch"
default["cloudwatchlogs"]["state_file_dir"] = "/var/awslogs/state"

hostname = node["opsworks"]["instance"]["hostname"]
instance_layers = node["opsworks"]["instance"]["layers"]

# Collect log_streams from all layers that the instance is attached to
# Set the default log_stream_name to be the opsworks instance id
default["cloudwatchlogs"]["log_streams"] = instance_layers.map do |layer_name|
  cloud_watch_logs_configuration = node["opsworks"]["layers"][layer_name].fetch("cloud_watch_logs_configuration", {})
  enabled = cloud_watch_logs_configuration["enabled"]
  log_streams = cloud_watch_logs_configuration["log_streams"]
  log_streams.map { |stream| { "log_stream_name" => hostname }.merge(stream) } unless log_streams.nil? || !enabled
end.compact.flatten
