#
# Cookbook Name:: newrelic
# Attributes:: java_agent
#
# Copyright 2012-2015, Escape Studios
#

default['newrelic']['java_agent']['version'] = '3.9.0'
version = node['newrelic']['java_agent']['version']
default['newrelic']['java_agent']['https_download'] = "https://download.newrelic.com/newrelic/java-agent/newrelic-agent/#{version}/newrelic-agent-#{version}.jar"
default['newrelic']['java_agent']['jar_file'] = "newrelic-agent-#{version}.jar"
default['newrelic']['java_agent']['install_dir'] = '/opt/newrelic/java'
default['newrelic']['java_agent']['app_user'] = 'newrelic'
default['newrelic']['java_agent']['app_group'] = 'newrelic'
default['newrelic']['java_agent']['audit_mode'] = false
default['newrelic']['java_agent']['log_file_count'] = 1
default['newrelic']['java_agent']['log_limit_in_kbytes'] = 0
default['newrelic']['java_agent']['log_daily'] = true
default['newrelic']['java_agent']['agent_action'] = :install
default['newrelic']['java_agent']['execute_agent_action'] = true
default['newrelic']['java_agent']['app_location'] = node['newrelic']['java_agent']['install_dir']
default['newrelic']['java_agent']['template']['cookbook'] = 'newrelic'
default['newrelic']['java_agent']['template']['source'] = 'agent/newrelic.yml.erb'
