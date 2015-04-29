#
# Cookbook Name:: newrelic
# Resource:: agent_php
#
# Copyright 2012-2015, Escape Studios
#

actions :install, :remove
default_action :install

attribute :license, :kind_of => String, :default => nil
attribute :config_file, :kind_of => String, :default => nil
attribute :startup_mode, :kind_of => String, :default => 'agent'
attribute :app_name, :kind_of => String, :default => nil
attribute :high_security, :kind_of => [TrueClass, FalseClass], :default => false
attribute :install_silently, :kind_of => [TrueClass, FalseClass], :default => false
attribute :config_file_to_be_deleted, :kind_of => String, :default => nil
attribute :service_name, :kind_of => String, :default => nil
attribute :execute_php5enmod, :kind_of => [TrueClass, FalseClass], :default => false
attribute :cookbook_ini, :kind_of => String, :default => 'newrelic'
attribute :source_ini, :kind_of => String, :default => 'agent/php/newrelic.ini.erb'
attribute :cookbook, :kind_of => String, :default => 'newrelic'
attribute :source, :kind_of => String, :default => 'agent/php/newrelic.cfg.erb'

attribute :enabled, :kind_of => [TrueClass, FalseClass], :default => true
attribute :logfile, :kind_of => String, :default => nil
attribute :loglevel, :kind_of => String, :default => nil
attribute :daemon_logfile, :kind_of => String, :default => '/var/log/newrelic/newrelic-daemon.log'
attribute :daemon_loglevel, :kind_of => String, :default => nil
attribute :daemon_port, :kind_of => String, :default => nil
attribute :daemon_max_threads, :kind_of => String, :default => nil
attribute :daemon_ssl, :kind_of => [TrueClass, FalseClass], :default => true
attribute :daemon_ssl_ca_path, :kind_of => String, :default => nil
attribute :daemon_ssl_ca_bundle, :kind_of => String, :default => nil
attribute :daemon_proxy, :kind_of => String, :default => nil
attribute :daemon_pidfile, :kind_of => String, :default => nil
attribute :daemon_location, :kind_of => String, :default => nil
attribute :daemon_collector_host, :kind_of => String, :default => nil
attribute :daemon_dont_launch, :kind_of => String, :default => nil
attribute :capture_params, :kind_of => [TrueClass, FalseClass], :default => false
attribute :ignored_params, :kind_of => String, :default => nil
attribute :error_collector_enable, :kind_of => [TrueClass, FalseClass], :default => true
attribute :error_collector_record_database_errors, :kind_of => [TrueClass, FalseClass], :default => true
attribute :error_collector_prioritize_api_errors, :kind_of => [TrueClass, FalseClass], :default => false
attribute :browser_monitoring_auto_instrument, :kind_of => [TrueClass, FalseClass], :default => true
attribute :transaction_tracer_enable, :kind_of => [TrueClass, FalseClass], :default => true
attribute :transaction_tracer_threshold, :kind_of => String, :default => nil
attribute :transaction_tracer_detail, :kind_of => String, :default => nil
attribute :transaction_tracer_slow_sql, :kind_of => [TrueClass, FalseClass], :default => true
attribute :transaction_tracer_stack_trace_threshold, :kind_of => String, :default => nil
attribute :transaction_tracer_explain_threshold, :kind_of => String, :default => nil
attribute :transaction_tracer_record_sql, :kind_of => String, :default => nil
attribute :transaction_tracer_custom, :kind_of => String, :default => nil
attribute :framework, :kind_of => String, :default => nil
attribute :webtransaction_name_remove_trailing_path, :kind_of => [TrueClass, FalseClass], :default => false
attribute :webtransaction_name_functions, :kind_of => String, :default => nil
attribute :webtransaction_name_files, :kind_of => String, :default => nil
attribute :cross_application_tracer_enable, :kind_of => [TrueClass, FalseClass], :default => true
