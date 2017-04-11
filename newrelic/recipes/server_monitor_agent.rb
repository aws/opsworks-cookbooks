#
# Cookbook Name:: newrelic
# Recipe:: server_monitor_agent
#
# Copyright 2012-2015, Escape Studios
#

newrelic_server_monitor 'Install' do
  license NewRelic.server_monitoring_license(node)
  logfile node['newrelic']['server_monitoring']['logfile'] unless node['newrelic']['server_monitoring']['logfile'].nil?
  loglevel node['newrelic']['server_monitoring']['loglevel'] unless node['newrelic']['server_monitoring']['loglevel'].nil?
  proxy node['newrelic']['server_monitoring']['proxy'] unless node['newrelic']['server_monitoring']['proxy'].nil?
  ssl NewRelic.to_boolean(node['newrelic']['server_monitoring']['ssl']) unless node['newrelic']['server_monitoring']['ssl'].nil?
  ssl_ca_bundle node['newrelic']['server_monitoring']['ssl_ca_bundle'] unless node['newrelic']['server_monitoring']['ssl_ca_bundle'].nil?
  ssl_ca_path node['newrelic']['server_monitoring']['ssl_ca_path'] unless node['newrelic']['server_monitoring']['ssl_ca_path'].nil?
  hostname node['newrelic']['server_monitoring']['hostname'] unless node['newrelic']['server_monitoring']['hostname'].nil?
  labels node['newrelic']['server_monitoring']['labels'] unless node['newrelic']['server_monitoring']['labels'].nil?
  pidfile node['newrelic']['server_monitoring']['pidfile'] unless node['newrelic']['server_monitoring']['pidfile'].nil?
  collector_host node['newrelic']['server_monitoring']['collector_host'] unless node['newrelic']['server_monitoring']['collector_host'].nil?
  timeout node['newrelic']['server_monitoring']['timeout'] unless node['newrelic']['server_monitoring']['timeout'].nil?
  config_file_user node['newrelic']['server_monitor_agent']['config_file_user'] unless node['newrelic']['server_monitor_agent']['config_file_user'].nil?
  config_file_group node['newrelic']['server_monitor_agent']['config_file_group'] unless node['newrelic']['server_monitor_agent']['config_file_group'].nil?
  service_notify_action node['newrelic']['server_monitor_agent']['service_notify_action'] unless node['newrelic']['server_monitor_agent']['service_notify_action'].nil?
  service_actions node['newrelic']['server_monitor_agent']['service_actions'] unless node['newrelic']['server_monitor_agent']['service_actions'].nil?
  windows_version node['newrelic']['server_monitor_agent']['windows_version'] unless node['newrelic']['server_monitor_agent']['windows_version'].nil?
  windows32_checksum node['newrelic']['server_monitor_agent']['windows32_checksum'] unless node['newrelic']['server_monitor_agent']['windows32_checksum'].nil?
  windows64_checksum node['newrelic']['server_monitor_agent']['windows64_checksum'] unless node['newrelic']['server_monitor_agent']['windows64_checksum'].nil?
  cookbook node['newrelic']['server_monitor_agent']['template']['cookbook'] unless node['newrelic']['server_monitor_agent']['template']['cookbook'].nil?
  source node['newrelic']['server_monitor_agent']['template']['source'] unless node['newrelic']['server_monitor_agent']['template']['source'].nil?
  service_name node['newrelic']['server_monitor_agent']['service_name'] unless node['newrelic']['server_monitor_agent']['service_name'].nil?
  config_path node['newrelic']['server_monitor_agent']['config_path'] unless node['newrelic']['server_monitor_agent']['config_path'].nil?
end
