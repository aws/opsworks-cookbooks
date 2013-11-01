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

package node['jvm_pkg']['name'] do
  action :install
  not_if { node['jvm_pkg']['use_custom_pkg_location'] }
end

bash "update the Java alternatives" do
  pkg_file_extension = ::File.extname(node['jvm_pkg']['custom_pkg_file'])
  code <<-EOC
    if [[ "#{pkg_file_extension}" = ".rpm" ]]; then
      FILELIST=$(rpm -qlp #{node['jvm_pkg']['custom_pkg_file']} | grep /bin/ | grep -v -e /db/ -e /jre/ -e /$ | xargs -n1 basename | grep -v ^java$ | xargs echo)
      JAVA_BIN_DIR=$(rpm -qlp #{node['jvm_pkg']['custom_pkg_file']} | grep /bin/ | grep -v -e /db/ -e /jre/ -e /$ | head -1 | xargs -n1 dirname)
    else
      FILELIST=$(tar -tzf #{node['jvm_pkg']['custom_pkg_file']} | grep /bin/ | grep -v -e /db/ -e /jre/ -e /$ | xargs -n1 basename | grep -v ^java$ | xargs echo)
      JAVA_BIN_DIR="#{node['jvm_pkg']['java_home_basedir']}/$(tar -tzf #{node['jvm_pkg']['custom_pkg_file']} | grep /bin/ | grep -v -e /db/ -e /jre/ -e /$ | head -1 | xargs -n1 dirname)"
    fi
    SLAVE_ARGS=""
    for FILENAME in $FILELIST; do
      SLAVE_ARGS="$SLAVE_ARGS --slave /usr/bin/$FILENAME $FILENAME $JAVA_BIN_DIR/$FILENAME"
    done
    update-alternatives --install /usr/bin/java java $JAVA_BIN_DIR/java 1061 $SLAVE_ARGS
    update-alternatives --set java $JAVA_BIN_DIR/java
  EOC
  action :nothing
end

execute "extract #{node['jvm_pkg']['custom_pkg_file']} to #{node['jvm_pkg']['java_home_basedir']}" do
  command "tar -xzf #{node['jvm_pkg']['custom_pkg_file']}"
  cwd node['jvm_pkg']['java_home_basedir']
  action :nothing
  notifies :run, "bash[update the Java alternatives]"
end

execute "install #{node['jvm_pkg']['custom_pkg_file']}" do
  command "rpm -Uvh #{node['jvm_pkg']['custom_pkg_file']}"
  action :nothing
  notifies :run, "bash[update the Java alternatives]"
end

remote_file node['jvm_pkg']['custom_pkg_file'] do
  source node['jvm_pkg']["custom_pkg_location_url_#{node[:platform_family]}"]
  only_if { node['jvm_pkg']['use_custom_pkg_location'] }
  case ::File.extname(node['jvm_pkg']['custom_pkg_file'])
  when '.rpm'
    notifies :run, "execute[install #{node['jvm_pkg']['custom_pkg_file']}]"
  else
    notifies :run, "execute[extract #{node['jvm_pkg']['custom_pkg_file']} to #{node['jvm_pkg']['java_home_basedir']}]"
  end
end

# cleanup of formerly installed Java or update-alternatives
