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
    apt_repository 'logentries' do
      uri 'http://rep.logentries.com/'
      distribution node['lsb']['codename']
      components ['main']
      keyserver node['le']['pgp_key_server']
      key 'C43C79AD'
      retries 3
    end
  when 'centos', 'redhat', 'amazon', 'scientific'
    yum_repository 'logentries' do
      description 'Logentries repo'
      baseurl 'http://rep.logentries.com/rh/\$basearch'
      gpgkey 'http://rep.logentries.com/RPM-GPG-KEY-logentries'
      action :create
      retries 3
    end
  when 'debian'
    apt_repository 'logentries' do
      uri 'http://rep.logentries.com/'
      distribution node['lsb']['codename']
      components ['main']
      keyserver node['le']['pgp_key_server']
      key 'C43C79AD'
      retries 3
    end
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
