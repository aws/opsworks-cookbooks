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

  template "/opt/solr/bin/solr.in.sh" do
    source "solr.in.sh.erb"
    owner deploy[:user]
    group 'www-data'
    mode 0440
    variables({
      :SOLR_MAX_MEM => node[:config][env][:SOLR_MAX_MEM],
      :SOLR_MIN_MEM => node[:config][env][:SOLR_MIN_MEM]
    })

  end

  execute "if [ ! -d '/mnt/var/solr' ]; then mkdir /mnt/var/solr; fi;"

  execute '/opt/solr/bin/solr restart' do
    user "deploy"
  end
end
