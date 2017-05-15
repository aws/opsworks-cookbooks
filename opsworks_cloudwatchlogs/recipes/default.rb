if node["cloudwatchlogs"]["log_streams"].any?
  include_recipe "opsworks_cloudwatchlogs::install"
else
  include_recipe "opsworks_cloudwatchlogs::uninstall" if File.exists?(File.join(node["cloudwatchlogs"]["home_dir"], "INSTALLED_BY_OPSWORKS"))
end
