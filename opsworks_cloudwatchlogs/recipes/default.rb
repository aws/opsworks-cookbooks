if node["opsworks"]["cloud_watch_logs_configurations"].any?
  include_recipe "opsworks_cloudwatchlogs::install"
else
  include_recipe "opsworks_cloudwatchlogs::uninstall"
end
