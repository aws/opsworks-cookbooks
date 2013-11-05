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
    Chef::Log.debug("Skipping deploy::java-stop application #{application} as it is not a Java app")
    next
  end

  include_recipe "opsworks_java::#{node['opsworks_java']['java_app_server']}_service"
  
  execute "trigger #{node['opsworks_java']['java_app_server']} service stop" do
    command '/bin/true'
    notifies :stop, "service[#{node['opsworks_java']['java_app_server']}]"
  end

  include_recipe 'apache2::service'
  
  service 'apache2' do
    action :stop
  end
end

