# -*- coding: utf-8 -*-
#
# Cookbook Name:: rabbitmq
# Recipe:: community_plugins
#
# Copyright 2013, Grégoire Seux
# Copyright 2013, Chef Software, Inc.
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

include_recipe 'rabbitmq::default'

node['rabbitmq']['community_plugins'].each do |plugin, download_url|
  # This will only work for deb/rpm installations, such as Ubuntu, Fedora and CentOS
  # List of installation directory per installation method: https://www.rabbitmq.com/installing-plugins.html
  remote_file "/usr/lib/rabbitmq/lib/rabbitmq_server-#{node['rabbitmq']['version']}/plugins/#{plugin}.ez" do
    mode '0644'
    owner 'root'
    group 'root'
    source download_url
  end

  rabbitmq_plugin plugin do
    action :enable
    notifies :restart, "service[#{node['rabbitmq']['service_name']}]"
  end
end
