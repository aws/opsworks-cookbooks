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
    name = 'passenger-enterprise-server'
    ensured_version = node[:passenger][:version]
    versions = `#{node[:dependencies][:gem_binary]} list #{name}`
    versions = versions.scan(/(\d[a-zA-Z0-9\.]*)/).flatten.compact
    for version in versions
      next if version == ensured_version
      Chef::Log.info("Uninstalling version #{version} of Rubygem #{name}")
      system("#{node[:dependencies][:gem_binary]} uninstall #{name} -v=#{version} #{node['dependencies']['gem_uninstall_options']}")
    end
    if versions.include?(ensured_version)
      Chef::Log.info("Skipping installation of version #{ensured_version} of Rubygem #{name}: already installed")
    else
      Chef::Log.info("Installing version #{ensured_version} of Rubygem #{name}")
      system("#{node[:dependencies][:gem_binary]} install #{name} -v=#{ensured_version} --source https://#{node[:passenger][:order]}@www.phusionpassenger.com/enterprise_gems/ #{node['dependencies']['gem_install_options']}")
    end
  end
end

execute "passenger_module" do
  command 'passenger-install-apache2-module -a'
  creates node[:passenger][:module_path]
  notifies :restart, "service[apache2]"
end

