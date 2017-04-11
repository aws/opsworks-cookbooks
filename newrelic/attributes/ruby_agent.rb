#
# Cookbook Name:: newrelic
# Attributes:: ruby_agent
#
# Copyright 2012-2015, Escape Studios
#

default['newrelic']['ruby_agent']['agent_action'] = :install
default['newrelic']['ruby_agent']['install_dir'] = ''
default['newrelic']['ruby_agent']['app_user'] = 'newrelic'
default['newrelic']['ruby_agent']['app_group'] = 'newrelic'
default['newrelic']['ruby_agent']['audit_mode'] = false
default['newrelic']['ruby_agent']['log_file_count'] = 1
default['newrelic']['ruby_agent']['log_limit_in_kbytes'] = 0
default['newrelic']['ruby_agent']['log_daily'] = true
default['newrelic']['ruby_agent']['template']['cookbook'] = 'newrelic'
default['newrelic']['ruby_agent']['template']['source'] = 'agent/newrelic.yml.erb'
