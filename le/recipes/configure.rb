#
# Author:: Joe Heung <joe.heung@logentries.com>
# Cookbook Name:: logentries_agent
# Recipe:: configure
#
# Copyright 2015 Logentries, Revelops Ireland Ltd
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

service 'logentries' do
  supports :stop => true, :start => true, :restart => true
  action :nothing
end

le = node['le']
if not le['pull-server-side-config']
  execute 'logentries datahub from file' do
    command(lazy do

              cmd = "le reinit"
              cmd += ' --pull-server-side-config=False'

              datahub = le['datahub']
              if datahub['enable']
                cmd += ' --suppress-ssl' unless datahub['ssl']
                cmd += " --datahub=#{datahub['server_ip']}:#{datahub['port']}"
              end

              cmd
            end)

    not_if 'grep pull-server-side-config /etc/le/config'
    notifies :restart, 'service[logentries]'
  end
else
  execute 'initialize logentries daemon' do
    command(lazy do
              cmd = "le register"
              if le['account_key'].empty?
                account_key_item = data_bag_item(le['data_bag_name'], le['data_bag_item_name'])
                account_key = account_key_item['account_key']
              else
                account_key = le['account_key']
              end
              cmd += " --user-key #{account_key}"
              cmd += " --name='#{le['hostname']}'"
              cmd
            end)

    not_if 'le whoami'

    notifies :restart, 'service[logentries]'
  end
end

class Chef::Recipe
  include FollowLogs
end

# Follow logs from the JSON config
follow_logs()
