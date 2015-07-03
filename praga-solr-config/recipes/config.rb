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

  remote_directory "/opt/solr/server/solr" do
    files_mode '0640'
    mode '0770'
    owner 'deploy'
    source "config"
  end
  Chef::Log.info(node[:config])
  Chef::Log.info(env)

  template "/opt/solr/bin/solr.in.sh" do
    source "solr.in.sh.erb"
    owner deploy[:user]
    group 'www-data'
    mode 0440
    #variables({
    #  :SOLR_MAX_MEM => node[:config][env][:SOLR_MAX_MEM],
    #  :SOLR_MIN_MEM => node[:config][env][:SOLR_MIN_MEM]
    #})

  end
  execute 'chmod 755 /opt/solr/bin/sols'
  execute '/opt/solr/bin/solr restart' do
    user "deploy"
  end
end
