#
# Cookbook Name:: haproxy
# Recipe:: default
#
# Copyright 2009, Opscode, Inc.
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
   when 'ubuntu'
     package 'haproxy' do
        action :install
     end

   when 'amazon'
     remote_file "/tmp/#{node[:haproxy][:rpm]}" do
       source node[:haproxy][:rpm_url]
       action :create_if_missing

        not_if do
          system("rpm -q haproxy | grep -q 'haproxy-#{node[:haproxy][:version]}-#{node[:haproxy][:patchlevel]}'")
        end
     end

     rpm_package 'haproxy' do
       action :install
       source "/tmp/#{node[:haproxy][:rpm]}"

       not_if do
         system("rpm -q haproxy | grep -q 'haproxy-#{node[:haproxy][:version]}-#{node[:haproxy][:patchlevel]}'")
       end
     end
end

if platform?('debian','ubuntu')
  template '/etc/default/haproxy' do
    source 'haproxy-default.erb'
    owner 'root'
    group 'root'
    mode 0644
  end
end

include_recipe 'haproxy::service'

service 'haproxy' do
  action [:enable, :start]
end

template '/etc/haproxy/haproxy.cfg' do
  source 'haproxy.cfg.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, "service[haproxy]"
end
