#
# Cookbook Name:: newrelic
# Recipe:: java_agent
#
# Copyright 2012-2015, Escape Studios
#

include_recipe 'newrelic::repository'

license = NewRelic.application_monitoring_license(node)

# create the directory to install the jar into
directory node['newrelic']['java_agent']['install_dir'] do
  owner node['newrelic']['java_agent']['app_user']
  group node['newrelic']['java_agent']['app_group']
  recursive true
  mode 0775
  action :create
end

agent_jar = "#{node['newrelic']['java_agent']['install_dir']}/#{node['newrelic']['java_agent']['jar_file']}"

remote_file agent_jar do
  source node['newrelic']['java_agent']['https_download']
  owner node['newrelic']['java_agent']['app_user']
  group node['newrelic']['java_agent']['app_group']
  mode 0664
  action :create_if_missing
end

if node['newrelic']['application_monitoring']['app_name'].nil?
  node.set['newrelic']['application_monitoring']['app_name'] = node['hostname']
end

# configure your New Relic license key
newrelic_yml "#{node['newrelic']['java_agent']['install_dir']}/newrelic.yml" do
  agent_type 'java'
  template_cookbook node['newrelic']['java_agent']['template_cookbook']
  template_source node['newrelic']['java_agent']['template_source']
  enabled node['newrelic']['application_monitoring']['enabled']
  app_name node['newrelic']['application_monitoring']['app_name']
  high_security node['newrelic']['application_monitoring']['high_security']
  owner node['newrelic']['java_agent']['app_user']
  group node['newrelic']['java_agent']['app_group']
  license license
  logfile node['newrelic']['application_monitoring']['logfile']
  logfile_path node['newrelic']['application_monitoring']['logfile_path']
  loglevel node['newrelic']['application_monitoring']['loglevel']
  audit_mode node['newrelic']['java_agent']['audit_mode']
  log_file_count node['newrelic']['java_agent']['log_file_count']
  log_limit_in_kbytes node['newrelic']['java_agent']['log_limit_in_kbytes']
  log_daily node['newrelic']['java_agent']['log_daily']
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

# allow app_group to write to log_file_path
path = node['newrelic']['application_monitoring']['logfile_path']

until path.nil? || path.empty? || path == File::SEPARATOR
  directory path do
    group node['newrelic']['java_agent']['app_group']
    mode 0775
    action :create
  end

  path = File.dirname(path)
end

# execution of the install
execute 'newrelic-install' do
  command "sudo java -jar #{agent_jar} -s #{node['newrelic']['java_agent']['app_location']} #{node['newrelic']['java_agent']['agent_action']}"
  only_if { node['newrelic']['java_agent']['execute_agent_action'] == true }
end
