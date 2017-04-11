#
# Cookbook Name:: newrelic
# Recipe:: dotnet_agent
#
# Copyright 2012-2015, Escape Studios
#

include_recipe 'newrelic::repository'

license = NewRelic.application_monitoring_license(node)

windows_package 'Install New Relic .NET Agent' do
  source node['newrelic']['dotnet_agent']['https_download']
  options "/qb NR_LICENSE_KEY=#{license} INSTALLLEVEL=#{node['newrelic']['dotnet_agent']['install_level']}"
  installer_type :msi
  action node['newrelic']['dotnet_agent']['agent_action']
  not_if { File.exist?('C:\\Program Files\\New Relic\\.NET Agent') }
end
