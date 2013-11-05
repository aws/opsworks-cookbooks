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

tomcat_pkgs = value_for_platform_family(
  'debian' => ["tomcat#{node['opsworks_java']['tomcat']['base_version']}", 'libtcnative-1', 'libmysql-java'],
  'rhel' => ["tomcat#{node['opsworks_java']['tomcat']['base_version']}", 'tomcat-native', 'mysql-connector-java']
)

tomcat_pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

link ::File.join(node['opsworks_java']['tomcat']['lib_dir'], node['opsworks_java']['tomcat']['mysql_connector_jar']) do
  to ::File.join(node['opsworks_java']['tomcat']['java_shared_lib_dir'], node['opsworks_java']['tomcat']['mysql_connector_jar'])
  action :create
end

# remove the ROOT webapp, if it got installed by default
include_recipe 'opsworks_java::remove_root_webapp'
