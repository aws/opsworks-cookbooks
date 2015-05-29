#
# Cookbook Name:: newrelic
# Recipe:: ruby_agent
#
# Copyright 2012-2015, Escape Studios
#

include_recipe 'newrelic::repository'

license = NewRelic.application_monitoring_license(node)

gem_package 'newrelic_rpm' do
  action node['newrelic']['ruby_agent']['agent_action']
end

if node['newrelic']['application_monitoring']['app_name'].nil?
  node.set['newrelic']['application_monitoring']['app_name'] = node['hostname']
end

# configure your New Relic license key
newrelic_yml "#{node['newrelic']['ruby_agent']['install_dir']}/newrelic.yml" do
  agent_type 'ruby'
  template_cookbook node['newrelic']['ruby_agent']['template_cookbook']
  template_source node['newrelic']['ruby_agent']['template_source']
  enabled node['newrelic']['application_monitoring']['enabled']
  app_name node['newrelic']['application_monitoring']['app_name']
  high_security node['newrelic']['application_monitoring']['high_security']
  owner node['newrelic']['ruby_agent']['app_user']
  group node['newrelic']['ruby_agent']['app_group']
  license license
  logfile node['newrelic']['application_monitoring']['logfile']
  logfile_path node['newrelic']['application_monitoring']['logfile_path']
  loglevel node['newrelic']['application_monitoring']['loglevel']
  audit_mode node['newrelic']['ruby_agent']['audit_mode']
  log_file_count node['newrelic']['ruby_agent']['log_file_count']
  log_limit_in_kbytes node['newrelic']['ruby_agent']['log_limit_in_kbytes']
  log_daily node['newrelic']['ruby_agent']['log_daily']
  daemon_ssl node['newrelic']['application_monitoring']['daemon']['ssl']
  daemon_proxy node['newrelic']['application_monitoring']['daemon']['proxy']
  capture_params node['newrelic']['application_monitoring']['capture_params']
  ignored_params node['newrelic']['application_monitoring']['ignored_params']
  transaction_tracer_enable node['newrelic']['application_monitoring']['transaction_tracer']['enable']
  transaction_tracer_threshold node['newrelic']['application_monitoring']['transaction_tracer']['threshold']
  transaction_tracer_record_sql node['newrelic']['application_monitoring']['transaction_tracer']['record_sql']
  transaction_tracer_stack_trace_threshold node['newrelic']['application_monitoring']['transaction_tracer']['stack_trace_threshold']
  transaction_tracer_slow_sql node['newrelic']['application_monitoring']['transaction_tracer']['slow_sql']
  transaction_tracer_explain_threshold node['newrelic']['application_monitoring']['transaction_tracer']['explain_threshold']
  error_collector_enable node['newrelic']['application_monitoring']['error_collector']['enable']
  error_collector_ignore_errors node['newrelic']['application_monitoring']['error_collector']['ignore_errors']
  error_collector_ignore_status_codes node['newrelic']['application_monitoring']['error_collector']['ignore_status_codes']
  browser_monitoring_auto_instrument node['newrelic']['application_monitoring']['browser_monitoring']['auto_instrument']
  cross_application_tracer_enable node['newrelic']['application_monitoring']['cross_application_tracer']['enable']
  thread_profiler_enable node['newrelic']['application_monitoring']['thread_profiler']['enable']
end
