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

old_jvm_pkg_to_remove = value_for_platform_family(
  'debian' => '',
  'rhel' => 'java-1.6.0-openjdk'
)

local_custom_pkg_file = value_for_platform_family(
  'debian' => "/tmp/custom_jvm#{::File.extname(node['jvm_pkg']['custom_pkg_location_url_debian'])}",
  'rhel' => "/tmp/custom_jvm#{::File.extname(node['jvm_pkg']['custom_pkg_location_url_rhel'])}"
)

package "remove old JVM package #{old_jvm_pkg_to_remove}" do
  package_name old_jvm_pkg_to_remove
  action :nothing
  only_if { node['jvm_version'].to_i >= 7 }
end

# install OpenJDK in either case to satisfy package dependencies
package node['jvm_pkg']['name'] do
  action :install
  notifies :remove, "package[remove old JVM package #{old_jvm_pkg_to_remove}]", :immediately
end

bash "update the Java alternatives" do
  pkg_file_extension = ::File.extname(local_custom_pkg_file)
  code <<-EOC
    if [[ "#{pkg_file_extension}" = ".rpm" ]]; then
      JAVA_BIN_DIR=$(rpm -qlp #{local_custom_pkg_file} | grep /bin/ | grep -v -e /db/ -e /jre/ -e /$ | head -1 | xargs -n1 dirname)
      FILELIST=$(rpm -qlp #{local_custom_pkg_file} | grep $JAVA_BIN_DIR | xargs -n1 basename | grep -v ^java$ | xargs echo)
    else
      PARTIAL_JAVA_BIN_DIR=$(tar -tzf #{local_custom_pkg_file} | grep /bin/ | grep -v -e /db/ -e /jre/ -e /$ | head -1 | xargs -n1 dirname)
      JAVA_BIN_DIR="#{node['jvm_pkg']['java_home_basedir']}/$PARTIAL_JAVA_BIN_DIR"
      FILELIST=$(tar -tzf #{local_custom_pkg_file} | grep $PARTIAL_JAVA_BIN_DIR | xargs -n1 basename | grep -v ^java$ | xargs echo)
    fi
    if [[ "#{node[:platform_family]}" = "debian" ]]; then
      update-alternatives --install /usr/bin/java java $JAVA_BIN_DIR/java 1061
      for FILENAME in $FILELIST; do
        update-alternatives --install /usr/bin/$FILENAME $FILENAME $JAVA_BIN_DIR/$FILENAME 1061
      done
    else
      SLAVE_ARGS=""
      for FILENAME in $FILELIST; do
        SLAVE_ARGS="$SLAVE_ARGS --slave /usr/bin/$FILENAME $FILENAME $JAVA_BIN_DIR/$FILENAME"
      done
      update-alternatives --install /usr/bin/java java $JAVA_BIN_DIR/java 1061 $SLAVE_ARGS
    fi
    update-alternatives --set java $JAVA_BIN_DIR/java
  EOC
  action :nothing
end

execute "extract #{local_custom_pkg_file} to #{node['jvm_pkg']['java_home_basedir']}" do
  command "tar -xzf #{local_custom_pkg_file}"
  cwd node['jvm_pkg']['java_home_basedir']
  action :nothing
  notifies :run, 'bash[update the Java alternatives]', :immediately
end

directory node['jvm_pkg']['java_home_basedir'] do
  owner 'root'
  group 'root'
  mode 0755
  action :nothing
end

rpm_package local_custom_pkg_file do
  action :nothing
  notifies :run, 'bash[update the Java alternatives]', :immediately
  only_if { node[:platform_family] == 'rhel' }
end

remote_file local_custom_pkg_file do
  source node['jvm_pkg']["custom_pkg_location_url_#{node[:platform_family]}"]
  only_if { node['jvm_pkg']['use_custom_pkg_location'] }
  if ::File.extname(local_custom_pkg_file) == '.rpm'
    notifies :install, "rpm_package[#{local_custom_pkg_file}]", :immediately
  else
    notifies :create, "directory[#{node['jvm_pkg']['java_home_basedir']}]", :immediately
    notifies :run, "execute[extract #{local_custom_pkg_file} to #{node['jvm_pkg']['java_home_basedir']}]", :immediately
  end
end

include_recipe 'opsworks_java::tomcat_setup'
