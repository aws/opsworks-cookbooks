#
# Cookbook Name:: praga-solr-opsworks-cookbook
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
node[:deploy].each do |app_name, deploy|
  Chef::Log.info(deploy)

  env = deploy["rails_env"]
  execute "mv #{node[:config][env][:path]}/solr #{node[:config][env][:path]}/solr-default"
  remote_directory "#{node[:config][env][:path]}" do
    files_mode '0640'
    mode '0770'
    owner 'deploy'
    source "config"
  end

  service 'solr' do
    supports :restart => true, :status => true
    action [:enable, :start]
  end
end
