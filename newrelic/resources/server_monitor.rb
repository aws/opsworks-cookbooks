#
# Cookbook Name:: newrelic
# Resource:: server_monitor
#
# Copyright 2012-2015, Escape Studios
#

actions :install, :remove
default_action :install

attribute :license, :kind_of => String, :default => nil

attribute :logfile, :kind_of => String, :default => nil
attribute :loglevel, :kind_of => String, :default => nil
attribute :proxy, :kind_of => String, :default => nil
attribute :ssl, :kind_of => [TrueClass, FalseClass], :default => true
attribute :ssl_ca_bundle, :kind_of => String, :default => nil
attribute :ssl_ca_path, :kind_of => String, :default => nil
attribute :hostname, :kind_of => String, :default => nil
attribute :labels, :kind_of => String, :default => nil
attribute :pidfile, :kind_of => String, :default => nil
attribute :collector_host, :kind_of => String, :default => nil
attribute :timeout, :kind_of => String, :default => nil

attribute :config_file_user, :kind_of => String, :default => 'root'
attribute :service_notify_action, :kind_of => String, :default => 'restart'
attribute :service_actions, :kind_of => Array, :default => %w(enable start)
attribute :windows_version, :kind_of => String, :default => '2.0.0.198'
attribute :windows64_checksum, :kind_of => String, :default => '5a8f3f5e8f15997463430401756d377c321c8899c2790ca85e5587a5b643651e'
attribute :windows32_checksum, :kind_of => String, :default => 'ac2b65eecaad461fdd2e4386e3e4c9f96ea940b35bdf7a8c532c21dbd1c99ff0'
attribute :cookbook, :kind_of => String, :default => 'newrelic'
attribute :source, :kind_of => String, :default => 'agent/server_monitor/nrsysmond.cfg.erb'

case node['platform']
when 'smartos'
  attribute :service_name, :kind_of => String, :default => 'nrsysmond'
  attribute :config_file_group, :kind_of => String, :default => 'root'
  attribute :config_path, :kind_of => String, :default => '/opt/local/etc'
else
  attribute :service_name, :kind_of => String, :default => 'newrelic-sysmond'
  attribute :config_file_group, :kind_of => String, :default => 'newrelic'
  attribute :config_path, :kind_of => String, :default => '/etc/newrelic'
end
