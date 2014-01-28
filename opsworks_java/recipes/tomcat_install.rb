tomcat_pkgs = value_for_platform_family(
  'debian' => ["tomcat#{node['opsworks_java']['tomcat']['base_version']}", 'libtcnative-1', 'libmysql-java'],
  'rhel' => ["tomcat#{node['opsworks_java']['tomcat']['base_version']}", 'tomcat-native', 'mysql-connector-java']
)

tomcat_pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

directory node['opsworks_java']['tomcat']['lib_dir_ext'] do
  owner 'root'
  group 'root'
  mode 0755
  action :create
end

directory node['opsworks_java']['tomcat']['java_shared_lib_dir_ext'] do
  owner 'root'
  group 'root'
  mode 0755
  action :create
end

  cookbook_file "{['opsworks_java']['tomcat']['java_shared_lib_dir_ext']}/activation.jar" do
    source "activation.jar"
    mode "0644"
    cookbook 'opsworks_java'
  end
  cookbook_file "{['opsworks_java']['tomcat']['java_shared_lib_dir_ext']}/ccpp.jar" do
    source "ccpp.jar"
    mode "0644"
    cookbook 'opsworks_java'
  end
  cookbook_file "{['opsworks_java']['tomcat']['java_shared_lib_dir_ext']}/hsql.jar" do
    source "hsql.jar"
    mode "0644"
    cookbook 'opsworks_java'
  end
  cookbook_file "{['opsworks_java']['tomcat']['java_shared_lib_dir_ext']}/jms.jar" do
    source "jms.jar"
    mode "0644"
    cookbook 'opsworks_java'
  end
  cookbook_file "{['opsworks_java']['tomcat']['java_shared_lib_dir_ext']}/jta.jar" do
    source "jta.jar"
    mode "0644"
    cookbook 'opsworks_java'
  end
  cookbook_file "{['opsworks_java']['tomcat']['java_shared_lib_dir_ext']}/jtds.jar" do
    source "jtds.jar"
    mode "0644"
    cookbook 'opsworks_java'
  end
  cookbook_file "{['opsworks_java']['tomcat']['java_shared_lib_dir_ext']}/junit.jar" do
    source "junit.jar"
    mode "0644"
    cookbook 'opsworks_java'
  end
  cookbook_file "{['opsworks_java']['tomcat']['java_shared_lib_dir_ext']}/jtuf7.jar" do
    source "jutf7.jar"
    mode "0644"
    cookbook 'opsworks_java'
  end
  cookbook_file "{['opsworks_java']['tomcat']['java_shared_lib_dir_ext']}/mail.jar" do
    source "mail.jar"
    mode "0644"
    cookbook 'opsworks_java'
  end
  cookbook_file "{['opsworks_java']['tomcat']['java_shared_lib_dir_ext']}/mysql.jar" do
    source "mysql.jar"
    mode "0644"
    cookbook 'opsworks_java'
  end
  cookbook_file "{['opsworks_java']['tomcat']['java_shared_lib_dir_ext']}/persistance.jar" do
    source "persistance.jar"
    mode "0644"
    cookbook 'opsworks_java'
  end
  cookbook_file "{['opsworks_java']['tomcat']['java_shared_lib_dir_ext']}/portal-service.jar" do
    source "portal-service.jar"
    mode "0644"
    cookbook 'opsworks_java'
  end
  cookbook_file "{['opsworks_java']['tomcat']['java_shared_lib_dir_ext']}/portlet.jar" do
    source "portlet.jar"
    mode "0644"
    cookbook 'opsworks_java'
  end
  cookbook_file "{['opsworks_java']['tomcat']['java_shared_lib_dir_ext']}/postgresql.jar" do
    source "postgresql.jar"
    mode "0644"
    cookbook 'opsworks_java'
  end
  cookbook_file "{['opsworks_java']['tomcat']['java_shared_lib_dir_ext']}/support-tomcat.jar" do
    source "support-tomcat.jar"
    mode "0644"
    cookbook 'opsworks_java'
  end

link ::File.join(node['opsworks_java']['tomcat']['lib_dir'], node['opsworks_java']['tomcat']['mysql_connector_jar']) do
  to ::File.join(node['opsworks_java']['tomcat']['java_shared_lib_dir'], node['opsworks_java']['tomcat']['mysql_connector_jar'])
  action :create
end

# remove the ROOT webapp, if it got installed by default
include_recipe 'opsworks_java::remove_root_webapp'
