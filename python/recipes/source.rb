#
# Author:: Seth Chisamore <schisamo@opscode.com>
# Cookbook Name:: python
# Recipe:: source
#
# Copyright 2011, Opscode, Inc.
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
#

include_recipe "build-essential"

configure_options = node['python']['configure_options'].join(" ")
make_options = node['python']['make_options'].join(" ")

packages = value_for_platform_family(
             "rhel" => ["openssl-devel","bzip2-devel","zlib-devel","expat-devel","db4-devel","sqlite-devel","ncurses-devel","readline-devel"],
             "default" => ["libssl-dev","libbz2-dev","zlib1g-dev","libexpat1-dev","libdb-dev","libsqlite3-dev","libncursesw5-dev","libncurses5-dev","libreadline-dev","libsasl2-dev", "libgdbm-dev"]
           )
#
packages.each do |dev_pkg|
  package dev_pkg
end

version = node['python']['version']
install_path = "#{node['python']['prefix_dir']}/bin/python#{version.split(/(^\d+\.\d+)/)[1]}"

remote_file "#{Chef::Config[:file_cache_path]}/Python-#{version}.tgz" do
  source "#{node['python']['url']}/#{version}/Python-#{version}.tgz"
  checksum node['python']['checksum']
  mode "0644"
  not_if { ::File.exists?(install_path) }
end

bash "build-and-install-python" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
  tar -zxvf Python-#{version}.tgz
  (cd Python-#{version} && ./configure #{configure_options})
  (cd Python-#{version} && make && make #{make_options})
  EOF
  environment({
      "LDFLAGS" => "-L#{node['python']['prefix_dir']} -L/usr/lib",
      "CPPFLAGS" => "-I#{node['python']['prefix_dir']} -I/usr/lib",
      "CXXFLAGS" => "-I#{node['python']['prefix_dir']} -I/usr/lib",
      "CFLAGS" => "-I#{node['python']['prefix_dir']} -I/usr/lib"
  }) if platform?("ubuntu") && node['platform_version'].to_f >= 12.04
  not_if { ::File.exists?(install_path) }
end

# Link install as the default python, to support Python 3.x
# Otherwise the pip and virtualenv recipes won't work properly
link node['python']['binary'] do
  to install_path
  not_if { ::File.exists?(node['python']['binary']) }
end


