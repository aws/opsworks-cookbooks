
# Author:: Caroline Fenlon <carfenlon@gmail.com>
# Cookbook Name:: logentries
# Recipe:: default
#
# Copyright 2011 Logentries, JLizard
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

execute "echo 'deb http://rep.logentries.com/ maverick main' >/etc/apt/sources.list.d/logentries.list"
execute "gpg --keyserver pgp.mit.edu --recv-keys C43C79AD && gpg -a --export C43C79AD | apt-key add -"
execute "apt-get update"
execute "apt-get install --yes logentries"
execute "le register --user-key #{node[:le][:userkey]} --name='#{node[:le][:hostname]}'"
execute "apt-get install --yes -qq logentries-daemon"

class Chef::Recipe
  include FollowLogs
end

# Follow logs from the JSON config
follow_logs()

# Start the service
execute "service logentries restart"
