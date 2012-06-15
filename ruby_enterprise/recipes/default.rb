#
# Cookbook Name:: ruby_enterprise
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

arch = RUBY_PLATFORM.match(/64/) ? 'amd64' : 'i386'

remote_file "/tmp/#{File.basename(node[:ruby_enterprise][:url][arch])}" do
  source node[:ruby_enterprise][:url][arch]
  not_if { ::File.exists?("/tmp/#{File.basename(node[:ruby_enterprise][:url][arch])}") }
end

package "ruby1.9" do
  action :remove
  ignore_failure true
end

execute "Install Ruby Enterprise Edition" do
  cwd "/tmp"
  command "dpkg -i /tmp/#{File.basename(node[:ruby_enterprise][:url][arch])} && (/usr/local/bin/gem uninstall -a bundler || echo '1')"

  not_if do
    ::File.exists?("/usr/local/bin/ruby") &&
    system("/usr/local/bin/ruby -v | grep -q '#{node[:ruby_enterprise][:version]}$'")
  end
end

if node[:platform].eql?('ubuntu') && ['11.10', '12.04'].include?("#{node[:platform_version]}")
  package 'libssl0.9.8'
end

template "/etc/environment" do
  source "environment.erb"
  mode "0644"
  owner "root"
  group "root"
end

template "/usr/local/bin/ruby_gc_wrapper.sh" do
  source "ruby_gc_wrapper.sh.erb"
  mode "0755"
  owner "root"
  group "root"
end

include_recipe('scalarium_rubygems')
include_recipe('scalarium_bundler')
