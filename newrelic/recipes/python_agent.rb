#
# Cookbook Name:: newrelic
# Recipe:: python_agent
#
# Copyright 2012-2015, Escape Studios
#

include_recipe 'newrelic::repository'

license = NewRelic.application_monitoring_license(node)

python_pip 'newrelic' do
  if node['newrelic']['python_agent']['python_venv']
    virtualenv node['newrelic']['python_agent']['python_venv']
  end
  action node['newrelic']['python_agent']['agent_action']
  if node['newrelic']['python_agent']['python_version'] != 'latest'
    version node['newrelic']['python_agent']['python_version']
  end
end

# configure your New Relic license key
template node['newrelic']['python_agent']['config_file'] do
  cookbook node['newrelic']['python_agent']['template']['cookbook']
  source node['newrelic']['python_agent']['template']['source']
  owner 'root'
  group 'root'
  mode 0644
  variables(
    :license => license,
    :app_name => node['newrelic']['application_monitoring']['app_name'],
    :high_security => node['newrelic']['application_monitoring']['high_security'],
    :enabled => node['newrelic']['application_monitoring']['enabled'],
    :logfile => node['newrelic']['application_monitoring']['logfile'],
    :loglevel => node['newrelic']['application_monitoring']['loglevel'],
    :daemon_ssl => node['newrelic']['application_monitoring']['daemon']['ssl'],
    :capture_params => node['newrelic']['application_monitoring']['capture_params'],
    :ignored_params => node['newrelic']['application_monitoring']['ignored_params'],
    :transaction_tracer_enable => node['newrelic']['application_monitoring']['transaction_tracer']['enable'],
    :transaction_tracer_threshold => node['newrelic']['application_monitoring']['transaction_tracer']['threshold'],
    :transaction_tracer_record_sql => node['newrelic']['application_monitoring']['transaction_tracer']['record_sql'],
    :transaction_tracer_stack_trace_threshold => node['newrelic']['application_monitoring']['transaction_tracer']['stack_trace_threshold'],
    :transaction_tracer_slow_sql => node['newrelic']['application_monitoring']['transaction_tracer']['slow_sql'],
    :transaction_tracer_explain_threshold => node['newrelic']['application_monitoring']['transaction_tracer']['explain_threshold'],
    :error_collector_enable => node['newrelic']['application_monitoring']['error_collector']['enable'],
    :error_collector_ignore_errors => node['newrelic']['application_monitoring']['error_collector']['ignore_errors'],
    :browser_monitoring_auto_instrument => node['newrelic']['application_monitoring']['browser_monitoring']['auto_instrument'],
    :cross_application_tracer_enable => node['newrelic']['application_monitoring']['cross_application_tracer']['enable'],
    :feature_flag => node['newrelic']['python_agent']['feature_flag'],
    :thread_profiler_enable => node['newrelic']['application_monitoring']['thread_profiler']['enable']
  )
  action :create
end
