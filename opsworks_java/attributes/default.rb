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
default['opsworks_java']['tomcat']['userdatabase_pathname'] = 'conf/tomcat-users.xml'
default['opsworks_java']['tomcat']['use_ssl_connector'] = false
default['opsworks_java']['tomcat']['use_threadpool'] = false
default['opsworks_java']['tomcat']['threadpool_max_threads'] = 150
default['opsworks_java']['tomcat']['threadpool_min_spare_threads'] = 4
default['opsworks_java']['tomcat']['connection_timeout'] = 20000
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
