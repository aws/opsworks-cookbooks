#
# Cookbook Name:: redisio
# Recipe:: disable
#
# Copyright 2013, Brian Bianco <brian.bianco@gmail.com>
#
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

redis = node['redisio']

redis['servers'].each do |current_server|
  server_name = current_server["name"] || current_server["port"]
  resource = resources("service[redis#{server_name}]")
  resource.action Array(resource.action)
  resource.action << :stop
  resource.action << :disable
end

