#
# Cookbook Name:: apache2
# Recipe:: service
#
# Copyright 2009, Peritor GmbH
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

service 'apache2' do
  service_name value_for_platform(
    ['centos','redhat','fedora','amazon'] => {'default' => 'httpd'},
    ['debian','ubuntu'] => {'default' => 'apache2'}
  )

  # If restarted/reloaded too quickly httpd has a habit of failing.
  # This may happen with multiple recipes notifying apache to restart - like
  # during the initial bootstrap.
  ['restart','reload'].each do |srv_cmd|
    send("#{srv_cmd}_command", value_for_platform(
        ['centos','redhat','fedora','amazon'] => {
          'default' => "/sbin/service httpd #{srv_cmd} && sleep 1"
        },
        ['debian','ubuntu'] => {
          'default' => "/etc/init.d/apache2 #{srv_cmd} && sleep 1"
        }
      )
    )
  end

  supports value_for_platform(
    'debian' => {
      '4.0' => [:restart, :reload],
      'default' => [:restart, :reload, :status]
    },
    'ubuntu' => { 'default' => [:restart, :reload, :status] },
    ['centos','redhat','fedora','amazon'] => { 'default' => [:restart, :reload, :status] },
    'default' => { 'default' => [:restart, :reload] }
  )

  action :nothing
end
