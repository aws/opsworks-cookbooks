#
# Cookbook Name:: praga-solr-opsworks-cookbook
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
node[:deploy].each do |app_name, deploy|

  remote_directory "/var/www/solr/server/solr" do
    files_mode '0640'
    mode '0770'
    owner 'deploy'
    source "config"
  end

  execute '/var/www/solr/bin/solr restart' do
    user "deploy"
  end
end
