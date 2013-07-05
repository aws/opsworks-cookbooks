#
# Cookbook Name:: apache2
# Recipe:: php5 
#
# Copyright 2008, OpsCode, Inc.
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

case node[:platform]
when 'debian', 'ubuntu'
  package 'libapache2-mod-php5' do
    action :install
  end  
when 'centos', 'redhat', 'fedora', 'amazon'
  package 'php' do
    action :install
    notifies :run, "execute[generate-module-list]", :immediately
    not_if 'which php'
  end

  # remove stock config
  file File.join(node[:apache][:dir], 'conf.d', 'php.conf') do
    action :delete
  end

  # replace with debian config
  template File.join(node[:apache][:dir], 'mods-available', 'php5.conf') do
    source 'mods/php5.conf.erb'
    notifies :restart, "service[apache2]"
  end
end

apache_module 'php5' do
  case node['platform']
  when 'redhat', 'centos', 'fedora', 'amazon'
    filename 'libphp5.so'
  end
end
