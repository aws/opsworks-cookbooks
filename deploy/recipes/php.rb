#
# Cookbook Name:: deploy
# Recipe:: php
#

include_recipe "deploy::user"
include_recipe "mod_php5_apache2"
include_recipe "mod_php5_apache2::php"

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'php'
    Chef::Log.debug("Skipping deploy::php application #{application} as it is not an PHP app")
    next
  end
  
  scalarium_deploy_user do
    deploy_data deploy
    app application
  end

  # create shared/ directory structure
  %w(log config system pids).each do |dir_name|
    directory "#{deploy[:deploy_to]}/shared/#{dir_name}" do
      group deploy[:group]
      owner deploy[:user]
      mode "0770"
      action :create
      recursive true  
    end
  end

  scalarium_deploy do
    deploy_data deploy
    app application
  end
end

