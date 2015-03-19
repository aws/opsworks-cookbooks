#
# Cookbook Name:: praga-solr-opsworks-cookbook
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
node[:deploy].each do |app_name, deploy|
  cookbook_file 'solr-install-sh' do
    path "/tmp/solr-install-sh"
    source "solr-install-sh"
  end
  execute '/bin/bash /tmp/solr-install-sh'
end
