#
# Cookbook Name:: praga-solr-opsworks-cookbook
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
node[:deploy].each do |app_name, deploy|
  remote_directory "/opt/solr/server/solr" do
    files_mode '0640'
    mode '0770'
    owner 'solr'
    source "config"
  end

  execute '/opt/solr/bin/solr restart' do
    user "solr"
  end
end
