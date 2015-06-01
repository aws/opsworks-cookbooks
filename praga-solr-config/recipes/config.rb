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
    owner 'deploy'
    source "config"
  end

  execute "if [ ! -d '/mnt/var/solr' ]; then mkdir /mnt/var/solr; fi;"

  execute '/opt/solr/bin/solr restart' do
    user "deploy"
  end
end
