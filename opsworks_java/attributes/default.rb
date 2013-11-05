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

default['opsworks_java'] = {}

default['opsworks_java']['jvm'] = 'openjdk'
default['opsworks_java']['jvm_version'] = '7'
default['opsworks_java']['jvm_options'] = ''
default['opsworks_java']['java_app_server'] = 'tomcat'
default['opsworks_java']['java_app_server_version'] = '7.0'

default['opsworks_java']['jvm_pkg'] = {}
default['opsworks_java']['jvm_pkg']['use_custom_pkg_location'] = false
default['opsworks_java']['jvm_pkg']['custom_pkg_location_url_debian'] = 'http://aws.amazon.com/'
default['opsworks_java']['jvm_pkg']['custom_pkg_location_url_rhel'] = 'https://aws.amazon.com/'
case node[:platform_family]
when 'debian'
  default['opsworks_java']['jvm_pkg']['name'] = "openjdk-#{node['opsworks_java']['jvm_version']}-jdk"
when 'rhel'
  default['opsworks_java']['jvm_pkg']['name'] = "java-1.#{node['opsworks_java']['jvm_version']}.0-openjdk-devel"
end
default['opsworks_java']['jvm_pkg']['java_home_basedir'] = '/usr/local'

default['opsworks_java']['datasources'] = {}

default['opsworks_java']['tomcat']['base_version'] = node['opsworks_java']['java_app_server_version'].to_i
default['opsworks_java']['tomcat']['service_name'] = "tomcat#{node['opsworks_java']['tomcat']['base_version']}"
default['opsworks_java']['tomcat']['port'] = 8080
default['opsworks_java']['tomcat']['secure_port'] = 8443
default['opsworks_java']['tomcat']['ajp_port'] = 8009
default['opsworks_java']['tomcat']['shutdown_port'] = 8005
default['opsworks_java']['tomcat']['uri_encoding'] = 'UTF-8'
default['opsworks_java']['tomcat']['unpack_wars'] = true
default['opsworks_java']['tomcat']['auto_deploy'] = true
default['opsworks_java']['tomcat']['java_opts'] = node['opsworks_java']['jvm_options']
default['opsworks_java']['tomcat']['catalina_base_dir'] = "/etc/tomcat#{node['opsworks_java']['tomcat']['base_version']}"
default['opsworks_java']['tomcat']['webapps_base_dir'] = "/var/lib/tomcat#{node['opsworks_java']['tomcat']['base_version']}/webapps"
default['opsworks_java']['tomcat']['lib_dir'] = "/usr/share/tomcat#{node['opsworks_java']['tomcat']['base_version']}/lib"
default['opsworks_java']['tomcat']['java_shared_lib_dir'] = '/usr/share/java'
default['opsworks_java']['tomcat']['context_dir'] = ::File.join(node['opsworks_java']['tomcat']['catalina_base_dir'], 'Catalina', 'localhost')
default['opsworks_java']['tomcat']['mysql_connector_jar'] = 'mysql-connector-java.jar'
default['opsworks_java']['tomcat']['apache_tomcat_bind_mod'] = 'proxy_http' # or: 'proxy_ajp'
default['opsworks_java']['tomcat']['apache_tomcat_bind_path'] = '/'
default['opsworks_java']['tomcat']['webapps_dir_entries_to_delete'] = %w(config log public tmp)
case node[:platform_family]
when 'debian'
  default['opsworks_java']['tomcat']['user'] = "tomcat#{node['opsworks_java']['tomcat']['base_version']}"
  default['opsworks_java']['tomcat']['group'] = "tomcat#{node['opsworks_java']['tomcat']['base_version']}"
  default['opsworks_java']['tomcat']['system_env_dir'] = '/etc/default'
when 'rhel'
  default['opsworks_java']['tomcat']['user'] = 'tomcat'
  default['opsworks_java']['tomcat']['group'] = 'tomcat'
  default['opsworks_java']['tomcat']['system_env_dir'] = '/etc/sysconfig'
end
