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

directory "/var/lib/tomcat7/temp" do
  owner 'tomcat7'
  group 'tomcat7'
  mode 0755
  action :create
end

directory "/opt/liferay" do
  owner 'root'
  group 'root'
  mode 0777
  action :create
end

directory "/opt/liferay/license" do
  owner 'tomcat7'
  group 'tomcat7'
  mode 0777
  action :create
end

directory "/opt/liferay/data" do
  owner 'tomcat7'
  group 'tomcat7'
  mode 0777
  action :create
end

directory "/opt/liferay/data/hsql" do
  owner 'tomcat7'
  group 'tomcat7'
  mode 0777
  action :create
end

  cookbook_file "/opt/liferay/data/hsql/lportal.properties" do
  owner 'tomcat7'
  group 'tomcat7'
    source "lportal.properties"
    mode "0777"
  end

  cookbook_file "/opt/liferay/data/hsql/lportal.script" do
  owner 'tomcat7'
  group 'tomcat7'
    source "lportal.script"
    mode "0777"
  end


  cookbook_file "/usr/share/java/ext/activation.jar" do
    source "activation.jar"
    mode "0644"
  end
  cookbook_file "/usr/share/java/ext/ccpp.jar" do
    source "ccpp.jar"
    mode "0644"
  end
  cookbook_file "/usr/share/java/ext/hsql.jar" do
    source "hsql.jar"
    mode "0644"
  end
  cookbook_file "/usr/share/java/ext/jms.jar" do
    source "jms.jar"
    mode "0644"
  end
  cookbook_file "/usr/share/java/ext/jta.jar" do
    source "jta.jar"
    mode "0644"
  end
  cookbook_file "/usr/share/java/ext/jtds.jar" do
    source "jtds.jar"
    mode "0644"
  end
  cookbook_file "/usr/share/java/ext/junit.jar" do
    source "junit.jar"
    mode "0644"
  end
  cookbook_file "/usr/share/java/ext/jtuf7.jar" do
    source "jutf7.jar"
    mode "0644"
  end
  cookbook_file "/usr/share/java/ext/mail.jar" do
    source "mail.jar"
    mode "0644"
  end
  cookbook_file "/usr/share/java/ext/mysql.jar" do
    source "mysql.jar"
    mode "0644"
  end
  cookbook_file "/usr/share/java/ext/persistence.jar" do
    source "persistence.jar"
    mode "0644"
  end
  cookbook_file "/usr/share/java/ext/portal-service.jar" do
    source "portal-service.jar"
    mode "0644"
  end
  cookbook_file "/usr/share/java/ext/portlet.jar" do
    source "portlet.jar"
    mode "0644"
  end
  cookbook_file "/usr/share/java/ext/postgresql.jar" do
    source "postgresql.jar"
    mode "0644"
  end
  cookbook_file "/usr/share/java/ext/support-tomcat.jar" do
    source "support-tomcat.jar"
    mode "0644"
  end

  cookbook_file "/usr/share/java/ext/support-tomcat.jar" do
    source "support-tomcat.jar"
    mode "0644"
  end

  cookbook_file "/usr/share/tomcat7/bin/setenv.sh" do
  owner 'root'
  group 'root'
    source "setenv.sh"
    mode "0644"
  end

  cookbook_file "/usr/share/tomcat7/bin/commons-daemon.jar" do
  owner 'root'
  group 'root'
    source "commons-daemon.jar"
    mode "0644"
  end

  cookbook_file "/usr/share/tomcat7/bin/commons-daemon-native.tar.gz" do
  owner 'root'
  group 'root'
    source "commons-daemon-native.tar.gz"
    mode "0644"
  end

  cookbook_file "/usr/share/tomcat7/bin/tomcat-native.tar.gz" do
  owner 'root'
  group 'root'
    source "tomcat-native.tar.gz"
    mode "0644"
  end


  

link ::File.join(node['opsworks_java']['tomcat']['lib_dir'], node['opsworks_java']['tomcat']['mysql_connector_jar']) do
  to ::File.join(node['opsworks_java']['tomcat']['java_shared_lib_dir'], node['opsworks_java']['tomcat']['mysql_connector_jar'])
  action :create
end

# remove the ROOT webapp, if it got installed by default
include_recipe 'opsworks_java::remove_root_webapp'
