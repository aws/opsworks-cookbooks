# Copyright 2013 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You may not
# use this file except in compliance with the License. A copy of the License is
# located at
#
#     http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is distributed on
# an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
# or implied. See the License for the specific language governing permissions
# and limitations under the License.

include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'java'
    Chef::Log.debug("Skipping deploy::java application #{application} as it is not a Java app")
    next
  end

  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end

  current_dir = ::File.join(deploy[:deploy_to], 'current')
  webapp_dir = ::File.join(node['opsworks_java'][node['opsworks_java']['java_app_server']]['webapps_base_dir'], application)

  # opsworks_deploy creates some stub dirs, which are not needed for typical webapps
  ruby_block "remove unnecessary directory entries in #{current_dir}" do
    block do
      node['opsworks_java'][node['opsworks_java']['java_app_server']]['webapps_dir_entries_to_delete'].each do |dir_entry|
        ::FileUtils.rm_rf(::File.join(current_dir, dir_entry), :secure => true)
      end
    end
  end

  link webapp_dir do
    to current_dir
    action :create
  end

  include_recipe "opsworks_java::#{node['opsworks_java']['java_app_server']}_service"

  execute "trigger #{node['opsworks_java']['java_app_server']} service restart" do
    command '/bin/true'
    not_if { node['opsworks_java'][node['opsworks_java']['java_app_server']]['auto_deploy'].to_s == 'true' }
    notifies :restart, "service[#{node['opsworks_java']['java_app_server']}]"
  end
end

include_recipe 'opsworks_java::web_app'
include_recipe 'opsworks_java::context'
