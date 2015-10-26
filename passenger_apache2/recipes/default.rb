# original code license
#
# Cookbook Name:: passenger_apache2
# Recipe:: default
#
# Author:: Joshua Timberman (<joshua@opscode.com>)
# Author:: Joshua Sierles (<joshua@37signals.com>)
# Author:: Michael Hale (<mikehale@gmail.com>)
#
# Copyright:: 2009, Opscode, Inc
# Copyright:: 2009, 37signals
# Coprighty:: 2009, Michael Hale
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_recipe "packages"
include_recipe "gem_support"
include_recipe 'apache2::service'

case node[:platform]
when "centos","redhat","amazon"
  package "httpd-devel"
  if node['platform_version'].to_f < 6.0
    package 'curl-devel'
  else
    ['libcurl-devel','openssl-devel','zlib-devel'].each do |pkg|
      package pkg do
        action :upgrade
      end
    end
  end
else
  ['apache2-prefork-dev','libapr1-dev'].each do |pkg|
    package pkg do
      action :upgrade
    end
  end

  if node[:passenger][:version] >= '3.0.0'
    package 'libcurl4-openssl-dev'
  end
end

ruby_block "ensure only our passenger version is installed by deinstalling any other version" do
  block do
    ensure_only_gem_version('passenger', node[:passenger][:version])
  end
end

execute "passenger_module" do
  command 'passenger-install-apache2-module -a'
  creates node[:passenger][:module_path]
  notifies :restart, "service[apache2]"
end

bash "Enable selinux httpd_t for passenger" do
  user "root"
  code <<-EOH
    semanage permissive -a httpd_t
  EOH
  not_if { OpsWorks::ShellOut.shellout("/usr/sbin/semanage permissive -l") =~ /httpd_t/ }
  only_if { platform_family?("rhel") && ::File.exist?("/usr/sbin/getenforce") && OpsWorks::ShellOut.shellout("/usr/sbin/getenforce").strip == "Enforcing" }
end
