#
# Cookbook Name:: ruby
# Recipe:: default
#
# Author:: Jonathan Weiss (<jonathan.weiss@peritor.com>)
# 
# Copyright:: 2010, Peritor GmbH
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

case node[:platform]
when 'debian','ubuntu'
  remote_file "/tmp/#{node[:ruby][:deb]}" do
    source node[:ruby][:deb_url]
    action :create_if_missing

    not_if do
      ::File.exists?("/usr/local/bin/ruby") &&
      system("/usr/local/bin/ruby -v | grep -q '#{node[:ruby][:version]}'")
    end
  end

  package "ruby-enterprise" do
    action :remove
    ignore_failure true
  end

when 'centos','redhat','fedora','amazon'
  remote_file "/tmp/#{node[:ruby][:rpm]}" do
    source node[:ruby][:rpm_url]
    action :create_if_missing

    not_if do
      ::File.exists?("/usr/local/bin/ruby") &&
      system("/usr/local/bin/ruby -v | grep -q '#{node[:ruby][:version]}'")
    end
  end
end

execute "Install Ruby #{node[:ruby][:full_version]}" do
  cwd "/tmp"
  case node[:platform]
  when 'centos','redhat','fedora','amazon'
    command "rpm -Uvh /tmp/#{node[:ruby][:rpm]}"
  when 'debian','ubuntu'
    command "dpkg -i /tmp/#{node[:ruby][:deb]}"
  end

  not_if do
    ::File.exists?("/usr/local/bin/ruby") &&
    system("/usr/local/bin/ruby -v | grep -q '#{node[:ruby][:version]}'")
  end
end

execute 'Delete downloaded ruby packages' do
  command "rm -vf /tmp/#{node[:ruby][:deb]} /tmp/#{node[:ruby][:rpm]}"
  only_if do
     ::File.exists?("/tmp/#{node[:ruby][:deb]}") ||
     ::File.exists?("/tmp/#{node[:ruby][:rpm]}")
   end
end

include_recipe 'opsworks_rubygems'
include_recipe 'opsworks_bundler'
