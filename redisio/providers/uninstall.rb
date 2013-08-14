#
# Cookbook Name:: redisio
# Provider::uninstall
#
# Copyright 2013, Brian Bianco <brian.bianco@gmail.com>
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

action :run do
    #remove redis binaries
    execute "rm -rf /usr/local/bin/redis*" if ::File.exists?("/usr/local/bin/redis-server")

    #remove configuration file and init script for servers provided
    unless new_resource.servers.nil?
      new_resource.servers.each do |server|
        server_name = server['name'] || server['port'] 
        execute "rm -rf /etc/redis/#{server_name}.conf" if ::File.exists?("/etc/redis/#{server_name}.conf")
        execute "rm -rf /etc/init.d/redis#{server_name}" if ::File.exists?("/etc/init.d/redis#{server_name}")
        execute "rm -rf /etc/init/redis#{server_name}.conf" if ::File.exists?("/etc/init/redis#{server_name}.conf")
      end
    end
end
