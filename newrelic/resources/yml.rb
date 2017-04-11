#
# Cookbook Name:: newrelic
# Resource:: yml
#
# Copyright 2012-2015, Escape Studios
#

actions :generate
default_action :generate

attribute :yml_path, :kind_of => String, :name_attribute => true
attribute :template_cookbook, :kind_of => String, :default => 'newrelic'
attribute :template_source, :kind_of => String, :default => 'agent/newrelic.yml.erb'
attribute :app_name, :kind_of => String, :default => nil
attribute :high_security, :kind_of => [TrueClass, FalseClass, String], :default => nil
attribute :agent_type, :kind_of => String, :required => true, :regex => /^(java|ruby)$/
attribute :enabled, :kind_of => [TrueClass, FalseClass, String], :default => nil
attribute :owner, :kind_of => String, :default => nil
attribute :group, :kind_of => String, :default => nil
attribute :license, :kind_of => String, :default => NewRelic.application_monitoring_license(node)
attribute :logfile, :kind_of => String, :default => node['newrelic']['application_monitoring']['logfile']
attribute :logfile_path, :kind_of => String, :default => node['newrelic']['application_monitoring']['logfile']
attribute :loglevel, :kind_of => String, :default => node['newrelic']['application_monitoring']['loglevel']
attribute :audit_mode, :kind_of => [TrueClass, FalseClass, String], :default => nil
attribute :log_file_count, :default => nil
attribute :log_limit_in_kbytes, :default => nil
attribute :log_daily, :default => nil
attribute :daemon_ssl, :default => node['newrelic']['application_monitoring']['daemon']['ssl']
attribute :daemon_proxy, :default => node['newrelic']['application_monitoring']['daemon']['proxy']
attribute :capture_params, :default => node['newrelic']['application_monitoring']['capture_params']
attribute :ignored_params, :default => node['newrelic']['application_monitoring']['ignored_params']
attribute :transaction_tracer_enable, :default => node['newrelic']['application_monitoring']['transaction_tracer']['enable']
attribute :transaction_tracer_threshold, :default => node['newrelic']['application_monitoring']['transaction_tracer']['threshold']
attribute :transaction_tracer_record_sql, :default => node['newrelic']['application_monitoring']['transaction_tracer']['record_sql']
attribute :transaction_tracer_stack_trace_threshold, :default => node['newrelic']['application_monitoring']['transaction_tracer']['stack_trace_threshold']
attribute :transaction_tracer_slow_sql, :default => node['newrelic']['application_monitoring']['transaction_tracer']['slow_sql']
attribute :transaction_tracer_explain_threshold, :default => node['newrelic']['application_monitoring']['transaction_tracer']['explain_threshold']
attribute :error_collector_enable, :default => node['newrelic']['application_monitoring']['error_collector']['enable']
attribute :error_collector_ignore_errors, :default => node['newrelic']['application_monitoring']['error_collector']['ignore_errors']
attribute :error_collector_ignore_status_codes, :default => node['newrelic']['application_monitoring']['error_collector']['ignore_status_codes']
attribute :browser_monitoring_auto_instrument, :default => node['newrelic']['application_monitoring']['browser_monitoring']['auto_instrument']
attribute :cross_application_tracer_enable, :default => node['newrelic']['application_monitoring']['browser_monitoring']['auto_instrument']
attribute :thread_profiler_enable, :default => node['newrelic']['application_monitoring']['thread_profiler']['enable']
