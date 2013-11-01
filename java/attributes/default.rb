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

default['jvm'] = 'openjdk'
default['jvm_version'] = '7'
default['jvm_options'] = ''
default['java_app_server'] = 'tomcat'
default['java_app_server_version'] = '7.0'

default['jvm_pkg'] = {}
case node[:platform_family]
when 'debian'
  default['jvm_pkg']['name'] = "openjdk-#{node['jvm_version']}-jdk"
  default['jvm_pkg']['custom_pkg_file'] = '/tmp/custom_jdk.tgz'
when 'rhel'
  default['jvm_pkg']['name'] = "java-1.#{node['jvm_version']}.0-openjdk-devel"
  default['jvm_pkg']['custom_pkg_file'] = '/tmp/custom_jdk.rpm'
end
default['jvm_pkg']['use_custom_pkg_location'] = false
default['jvm_pkg']['custom_pkg_location_url_debian'] = ''
default['jvm_pkg']['custom_pkg_location_url_rhel'] = ''
default['jvm_pkg']['java_home_basedir'] = '/usr/local'

default['tomcat']['base_version'] = node['java_app_server_version'].to_i
default['tomcat']['service_name'] = "tomcat#{node['tomcat']['base_version']}"
default['tomcat']['port'] = 8080
default['tomcat']['secure_port'] = 8443
default['tomcat']['ajp_port'] = 8009
default['tomcat']['shutdown_port'] = 8005
default['tomcat']['uri_encoding'] = 'UTF-8'
default['tomcat']['unpack_wars'] = true
default['tomcat']['auto_deploy'] = true
default['tomcat']['java_opts'] = node['jvm_options']
default['tomcat']['catalina_base_dir'] = "/etc/tomcat#{node['tomcat']['base_version']}"
default['tomcat']['webapps_base_dir'] = "/var/lib/tomcat#{node['tomcat']['base_version']}/webapps"
default['tomcat']['lib_dir'] = "/usr/share/tomcat#{node['tomcat']['base_version']}/lib"
default['tomcat']['java_dir'] = '/usr/share/java'
default['tomcat']['context_dir'] = ::File.join(node['tomcat']['catalina_base_dir'], 'Catalina', 'localhost')
default['tomcat']['mysql_connector_jar'] = 'mysql-connector-java.jar'
default['tomcat']['apache_tomcat_bind_mod'] = 'proxy_http' # or: 'proxy_ajp'
default['tomcat']['apache_tomcat_bind_config'] = 'tomcat_bind.conf'
default['tomcat']['apache_tomcat_bind_path'] = '/'
default['tomcat']['webapps_dir_entries_to_delete'] = %w(config log public tmp)
case node[:platform_family]
when 'debian'
  default['tomcat']['user'] = "tomcat#{node['tomcat']['base_version']}"
  default['tomcat']['group'] = "tomcat#{node['tomcat']['base_version']}"
  default['tomcat']['system_env_dir'] = '/etc/default'
when 'rhel'
  default['tomcat']['user'] = 'tomcat'
  default['tomcat']['group'] = 'tomcat'
  default['tomcat']['system_env_dir'] = '/etc/sysconfig'
end
