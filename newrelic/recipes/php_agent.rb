#
# Cookbook Name:: newrelic
# Recipe:: php_agent
#
# Copyright 2012-2015, Escape Studios
#

newrelic_agent_php 'Install' do
  license NewRelic.application_monitoring_license(node)
  config_file node['newrelic']['php_agent']['config_file'] unless node['newrelic']['php_agent']['config_file'].nil?
  startup_mode node['newrelic']['php_agent']['startup_mode'] unless node['newrelic']['php_agent']['startup_mode'].nil?
  app_name node['newrelic']['application_monitoring']['app_name'] unless node['newrelic']['application_monitoring']['app_name'].nil?
  high_security NewRelic.to_boolean(node['newrelic']['application_monitoring']['high_security']) unless node['newrelic']['application_monitoring']['high_security'].nil?
  install_silently node['newrelic']['php_agent']['install_silently'] unless node['newrelic']['php_agent']['install_silently'].nil?
  config_file_to_be_deleted node['newrelic']['php_agent']['config_file_to_be_deleted'] unless node['newrelic']['php_agent']['config_file_to_be_deleted'].nil?
  service_name node['newrelic']['php_agent']['web_server']['service_name'] unless node['newrelic']['php_agent']['web_server']['service_name'].nil?
  execute_php5enmod NewRelic.to_boolean(node['newrelic']['php_agent']['execute_php5enmod']) unless node['newrelic']['php_agent']['execute_php5enmod'].nil?
  cookbook_ini node['newrelic']['php_agent']['template']['cookbook_ini'] unless node['newrelic']['php_agent']['template']['cookbook_ini'].nil?
  source_ini node['newrelic']['php_agent']['template']['source_ini'] unless node['newrelic']['php_agent']['template']['source_ini'].nil?
  cookbook node['newrelic']['php_agent']['template']['cookbook'] unless node['newrelic']['php_agent']['template']['cookbook'].nil?
  source node['newrelic']['php_agent']['template']['source'] unless node['newrelic']['php_agent']['template']['source'].nil?
  enabled node['newrelic']['application_monitoring']['enabled'] unless node['newrelic']['application_monitoring']['enabled'].nil?
  logfile node['newrelic']['application_monitoring']['logfile'] unless node['newrelic']['application_monitoring']['logfile'].nil?
  loglevel node['newrelic']['application_monitoring']['loglevel'] unless node['newrelic']['application_monitoring']['loglevel'].nil?
  daemon_logfile node['newrelic']['application_monitoring']['daemon']['logfile'] unless node['newrelic']['application_monitoring']['daemon']['logfile'].nil?
  daemon_loglevel node['newrelic']['application_monitoring']['daemon']['loglevel'] unless node['newrelic']['application_monitoring']['daemon']['loglevel'].nil?
  daemon_port node['newrelic']['application_monitoring']['daemon']['port'] unless node['newrelic']['application_monitoring']['daemon']['port'].nil?
  daemon_max_threads node['newrelic']['application_monitoring']['daemon']['max_threads'] unless node['newrelic']['application_monitoring']['daemon']['max_threads'].nil?
  daemon_ssl NewRelic.to_boolean(node['newrelic']['application_monitoring']['daemon']['ssl']) unless node['newrelic']['application_monitoring']['daemon']['ssl'].nil?
  daemon_ssl_ca_path node['newrelic']['application_monitoring']['daemon']['ssl_ca_path'] unless node['newrelic']['application_monitoring']['daemon']['ssl_ca_path'].nil?
  daemon_ssl_ca_bundle node['newrelic']['application_monitoring']['daemon']['ssl_ca_bundle'] unless node['newrelic']['application_monitoring']['daemon']['ssl_ca_bundle'].nil?
  daemon_proxy node['newrelic']['application_monitoring']['daemon']['proxy'] unless node['newrelic']['application_monitoring']['daemon']['proxy'].nil?
  daemon_pidfile node['newrelic']['application_monitoring']['daemon']['pidfile'] unless node['newrelic']['application_monitoring']['daemon']['pidfile'].nil?
  daemon_location node['newrelic']['application_monitoring']['daemon']['location'] unless node['newrelic']['application_monitoring']['daemon']['location'].nil?
  daemon_collector_host node['newrelic']['application_monitoring']['daemon']['collector_host'] unless node['newrelic']['application_monitoring']['daemon']['collector_host'].nil?
  daemon_dont_launch node['newrelic']['application_monitoring']['daemon']['dont_launch'] unless node['newrelic']['application_monitoring']['daemon']['dont_launch'].nil?
  capture_params NewRelic.to_boolean(node['newrelic']['application_monitoring']['capture_params']) unless node['newrelic']['application_monitoring']['capture_params'].nil?
  ignored_params node['newrelic']['application_monitoring']['ignored_params'] unless node['newrelic']['application_monitoring']['ignored_params'].nil?
  error_collector_enable NewRelic.to_boolean(node['newrelic']['application_monitoring']['error_collector']['enable']) unless node['newrelic']['application_monitoring']['error_collector']['enable'].nil?
  error_collector_record_database_errors NewRelic.to_boolean(node['newrelic']['application_monitoring']['error_collector']['record_database_errors']) unless node['newrelic']['application_monitoring']['error_collector']['record_database_errors'].nil?
  error_collector_prioritize_api_errors NewRelic.to_boolean(node['newrelic']['application_monitoring']['error_collector']['prioritize_api_errors']) unless node['newrelic']['application_monitoring']['error_collector']['prioritize_api_errors'].nil?
  browser_monitoring_auto_instrument NewRelic.to_boolean(node['newrelic']['application_monitoring']['browser_monitoring']['auto_instrument']) unless node['newrelic']['application_monitoring']['browser_monitoring']['auto_instrument'].nil?
  transaction_tracer_enable NewRelic.to_boolean(node['newrelic']['application_monitoring']['transaction_tracer']['enable']) unless node['newrelic']['application_monitoring']['transaction_tracer']['enable'].nil?
  transaction_tracer_threshold node['newrelic']['application_monitoring']['transaction_tracer']['threshold'] unless node['newrelic']['application_monitoring']['transaction_tracer']['threshold'].nil?
  transaction_tracer_detail node['newrelic']['application_monitoring']['transaction_tracer']['detail'] unless node['newrelic']['application_monitoring']['transaction_tracer']['detail'].nil?
  transaction_tracer_slow_sql NewRelic.to_boolean(node['newrelic']['application_monitoring']['transaction_tracer']['slow_sql']) unless node['newrelic']['application_monitoring']['transaction_tracer']['slow_sql'].nil?
  transaction_tracer_stack_trace_threshold node['newrelic']['application_monitoring']['transaction_tracer']['stack_trace_threshold'] unless node['newrelic']['application_monitoring']['transaction_tracer']['stack_trace_threshold'].nil?
  transaction_tracer_explain_threshold node['newrelic']['application_monitoring']['transaction_tracer']['explain_threshold'] unless node['newrelic']['application_monitoring']['transaction_tracer']['explain_threshold'].nil?
  transaction_tracer_record_sql node['newrelic']['application_monitoring']['transaction_tracer']['record_sql'] unless node['newrelic']['application_monitoring']['transaction_tracer']['record_sql'].nil?
  transaction_tracer_custom node['newrelic']['application_monitoring']['transaction_tracer']['custom'] unless node['newrelic']['application_monitoring']['transaction_tracer']['custom'].nil?
  framework node['newrelic']['application_monitoring']['framework'] unless node['newrelic']['application_monitoring']['framework'].nil?
  webtransaction_name_remove_trailing_path NewRelic.to_boolean(node['newrelic']['application_monitoring']['webtransaction']['name']['remove_trailing_path']) unless node['newrelic']['application_monitoring']['webtransaction']['name']['remove_trailing_path'].nil?
  webtransaction_name_functions node['newrelic']['application_monitoring']['webtransaction']['name']['functions'] unless node['newrelic']['application_monitoring']['webtransaction']['name']['functions'].nil?
  webtransaction_name_files node['newrelic']['application_monitoring']['webtransaction']['name']['files'] unless node['newrelic']['application_monitoring']['webtransaction']['name']['files'].nil?
  cross_application_tracer_enable NewRelic.to_boolean(node['newrelic']['application_monitoring']['cross_application_tracer']['enable']) unless node['newrelic']['application_monitoring']['cross_application_tracer']['enable'].nil?
end
