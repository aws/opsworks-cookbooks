#
# Cookbook Name:: solr
# Attributes:: default
#
# Copyright 2013, David Radcliffe
#

default['solr']['version']  = default['solr']['version'] || '5.2.1'
default['solr']['url']      = "https://archive.apache.org/dist/lucene/solr/#{node['solr']['version']}/solr-#{node['solr']['version']}.tgz"
default['solr']['data_dir'] = "/opt/solr-#{default['solr']['version']}/server"
default['solr']['cores_dir'] = "#{default['solr']['data_dir']}/solr"
default['solr']['dir']      = "/opt/solr"
default['solr']['port']     = '8984'
default['solr']['pid_file'] = '/var/run/solr.pid'
default['solr']['log_file'] = "/opt/solr-#{default['solr']['version']}/server/logs/solr.log"
default['solr']['user']     = 'deploy'
default['solr']['group']    = 'www-data'
default['solr']['install_java'] = true
default['solr']['java_options'] = '-Xms512M -Xmx20480M'


default[:logrotate][:rotate] = 30
default[:logrotate][:dateformat] = false # set to '-%Y%m%d' to have date formatted logs
  
