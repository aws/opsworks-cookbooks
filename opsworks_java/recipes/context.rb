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

include_recipe "opsworks_java::#{node['opsworks_java']['java_app_server']}_service"

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'java'
    Chef::Log.debug("Skipping deploy::java application #{application} as it is not a Java app")
    next
  end

  # ROOT has a special meaning and has to be capitalized
  if application == 'root'
    webapp_name = 'ROOT'
  else
    webapp_name = application
  end

  template "context file for #{webapp_name}" do
    path ::File.join(node['opsworks_java'][node['opsworks_java']['java_app_server']]['context_dir'], "#{webapp_name}.xml")
    source 'webapp_context.xml.erb'
    owner node['opsworks_java'][node['opsworks_java']['java_app_server']]['user']
    group node['opsworks_java'][node['opsworks_java']['java_app_server']]['group']
    mode 0640
    backup false
    only_if { node['opsworks_java']['datasources'][webapp_name] }
    variables(:resource_name => node['opsworks_java']['datasources'][webapp_name], :application => application)
    notifies :restart, "service[#{node['opsworks_java']['java_app_server']}]"
  end
end
