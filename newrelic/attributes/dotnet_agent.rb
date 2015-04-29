#
# Cookbook Name:: newrelic
# Attributes:: dotnet_agent
#
# Copyright 2012-2015, Escape Studios
#

default['newrelic']['dotnet_agent']['https_download'] = 'https://download.newrelic.com/dot_net_agent/release/x64'
default['newrelic']['dotnet_agent']['install_level'] = '1'
default['newrelic']['dotnet_agent']['agent_action'] = :install
