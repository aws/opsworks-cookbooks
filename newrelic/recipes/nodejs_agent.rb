#
# Cookbook Name:: newrelic
# Recipe:: nodejs_agent
#
# Copyright 2012-2015, Escape Studios
#

include_recipe 'newrelic::repository'

license = NewRelic.application_monitoring_license(node)

# install the newrelic.js file into each projects
node['newrelic']['nodejs_agent']['apps'].each do |nodeapp|
  execute 'npm-install-nodejs_agent' do
    cwd nodeapp['app_path']
    command "npm #{node['newrelic']['nodejs_agent']['agent_action']} newrelic"
  end

  if nodeapp.key?('app_log_level')
    app_log_level = nodeapp['app_log_level']
  else
    app_log_level = node['newrelic']['nodejs_agent']['default_app_log_level']
  end

  if nodeapp.key?('app_log_filepath')
    app_log_filepath = nodeapp['app_log_filepath']
  end

  template "#{nodeapp['app_path']}/newrelic.js" do
    cookbook node['newrelic']['nodejs_agent']['template']['cookbook']
    source node['newrelic']['nodejs_agent']['template']['source']
    variables(
      :license => license,
      :app_name => nodeapp['app_name'],
      :app_log_level => app_log_level,
      :app_log_filepath => app_log_filepath
    )
  end
end
