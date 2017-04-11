#
# Cookbook Name:: proftpd
# Recipe:: default
#
# Copyright 2009, Calogero Lo Leggio
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if node[:proftpd][:modules].include?('sql_mysql')
  package "proftpd-mod-mysql" do
    action :upgrade
  end
elsif node[:proftpd][:modules].include?('sql_postgres')
  package "proftpd-mod-pgsql" do
    action :upgrade
  end
else
  package "proftpd-basic" do
    action :upgrade
  end
end

if node[:proftpd][:modules].include?('ldap')
  package "proftpd-mod-ldap" do
    action :upgrade
  end
end

service "proftpd" do
  supports :status => true, :restart => true, :reload => true
end

directory "#{node[:proftpd][:dir]}/ssl" do
  owner node[:proftpd][:user]
  group node[:proftpd][:group]
  mode 0700
end

remote_directory "#{node[:proftpd][:dir]}/#{node[:proftpd][:dir_extra_conf]}" do
  source "conf.d"
  files_backup 0
  files_owner node[:proftpd][:user]
  files_group node[:proftpd][:group]
  files_mode 0600
  owner node[:proftpd][:user]
  group node[:proftpd][:group]
  mode 0700
end

template "#{node[:proftpd][:dir]}/modules.conf" do
  source "modules.conf.erb"
  mode 0644
  owner node[:proftpd][:user]
  group node[:proftpd][:group]
  notifies :restart, resources(:service => "proftpd")
end

template "#{node[:proftpd][:dir]}/proftpd.conf" do
  source "proftpd.conf.erb"
  mode 0644
  owner node[:proftpd][:user]
  group node[:proftpd][:group]
  notifies :restart, resources(:service => "proftpd")
end

if (node[:proftpd][:sql] == "on")
  template "#{node[:proftpd][:dir]}/#{node[:proftpd][:dir_extra_conf]}/sql.conf" do
    source "sql.conf.erb"
    mode 0644
    owner node[:proftpd][:user]
    group node[:proftpd][:group]
    notifies :restart, resources(:service => "proftpd")
  end
end

service "proftpd" do
  action [ :enable, :start ]
end
