#
# Cookbook Name:: rabbitmq
# Recipe:: mgmt_console
#
# Copyright 2012, Tacit Knowledge, Inc.
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

plugins = %w( rabbitmq_management rabbitmq_management_visualiser )

service_name = node['rabbitmq']['service_name']

plugins.each do |plugin|
  rabbitmq_plugin plugin do
    action :enable
    notifies :restart, "service[#{service_name}]", :immediately
  end
end
