#
# Author:: Joe Heung <joe.heung@logentries.com>
# Cookbook Name:: logentries_agent
# Recipe:: install
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



case node['platform']
  when 'ubuntu'
    execute "echo 'deb http://rep.logentries.com/ trusty main' >/etc/apt/sources.list.d/logentries.list"
    execute "gpg --keyserver pgp.mit.edu --recv-keys C43C79AD && gpg -a --export C43C79AD | apt-key add -"
    execute "apt-get update"
end

dont_run_file = '/etc/default/logentries_not_to_be_run'

file 'create_dont_run_file' do
  path dont_run_file
  action :create
  not_if 'test -e /etc/init.d/logentries'
end

file 'remove_dont_run_file' do
  path dont_run_file
  action :nothing
end

package %w(logentries logentries-daemon) do
  action :install
  notifies :delete, 'file[remove_dont_run_file]', :delayed
end
