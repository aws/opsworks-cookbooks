#
# Cookbook Name:: deploy_wrapper_test
# Recipe:: default
#
# Copyright (C) 2013 Cameron Johnston
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'git'
include_recipe 'deploy_wrapper'

deploy_wrapper 'dw_cookbook' do
  owner 'root'
  group 'root'
  ssh_wrapper_dir '/opt/dw_cookbook/shared'
  ssh_key_dir '/root/.ssh'
  ssh_key_data node['deploy_wrapper_test']['ssh_key_data']
  sloppy true
end

deploy_revision '/opt/dw_cookbook' do
  revision 'master'
  repo node['deploy_wrapper_test']['repo']
  ssh_wrapper '/opt/dw_cookbook/shared/dw_cookbook_deploy_wrapper.sh'
  symlink_before_migrate.clear
  symlinks.clear
end
