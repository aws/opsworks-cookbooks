# Author:: Nacer Laradji (<nacer.laradji@gmail.com>)
# Cookbook Name:: zabbix
# Recipe:: agent_package
#
# Copyright 2011, Efactures
#
# Apache 2.0
#

if node['platform'] == 'windows'
  include_recipe 'chocolatey'
  chocolatey 'zabbix-agent'
else
  case node['platform']
  when 'ubuntu', 'debian'
    include_recipe 'apt'
    apt_repository 'zabbix' do
      uri node['zabbix']['agent']['package']['repo_uri']
      distribution node['lsb']['codename']
      components ['main']
      key node['zabbix']['agent']['package']['repo_key']
      notifies :run, 'execute[apt-get update]', :immediately
    end
  when 'redhat', 'centos', 'scientific', 'oracle', 'amazon', 'fedora'
    include_recipe 'yum'
    yum_repository 'zabbix' do
      repositoryid 'zabbix'
      description 'Zabbix Official Repository'
      baseurl node['zabbix']['agent']['package']['repo_uri']
      gpgkey node['zabbix']['agent']['package']['repo_key']
      sslverify false
      action :create
    end

    yum_repository 'zabbix-non-supported' do
      repositoryid 'zabbix-non-supported'
      description 'Zabbix Official Repository non-supported - $basearch'
      baseurl node['zabbix']['agent']['package']['repo_uri']
      gpgkey node['zabbix']['agent']['package']['repo_key']
      sslverify false
      action :create
    end
  end
  package 'zabbix-agent'
end
