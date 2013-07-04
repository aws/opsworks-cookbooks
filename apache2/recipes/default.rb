#
# Cookbook Name:: apache2
# Recipe:: default
#
# Copyright 2008, OpsCode, Inc.
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

package 'apache2' do
  case node[:platform]
  when 'centos','redhat','fedora','amazon'
    package_name 'httpd'
  when 'debian','ubuntu'
    package_name 'apache2'
  end
  action :install
end

include_recipe 'apache2::service'

service 'apache2' do
  service_name value_for_platform(
    ['centos','redhat','fedora','amazon'] => {'default' => 'httpd'},
    'default' => 'apache2'
  )
  action :enable
end

if platform?("debian","ubuntu")
  execute "reset permission of #{node[:apache][:log_dir]}" do
    command "chmod 0755 #{node[:apache][:log_dir]}"
  end
end

execute 'logdir_existence_and_restart_apache2' do
  command "ls -la #{node[:apache][:log_dir]}"
  action :nothing
  notifies :restart, resources(:service => 'apache2')
end

if platform?('centos', 'redhat', 'fedora', 'amazon')
  directory node[:apache][:log_dir] do
    mode 0755
    action :create
  end

  cookbook_file '/usr/local/bin/apache2_module_conf_generate.pl' do
    source 'apache2_module_conf_generate.pl'
    mode 0755
    owner 'root'
    group 'root'
  end

  ['sites-available','sites-enabled','mods-available','mods-enabled'].each do |dir|
    directory "#{node[:apache][:dir]}/#{dir}" do
      mode 0755
      owner 'root'
      group 'root'
      action :create
    end
  end

  execute 'generate-module-list' do
    if node[:kernel][:machine] == 'x86_64'
      libdir = 'lib64'
    else
      libdir = 'lib'
    end
    command "/usr/local/bin/apache2_module_conf_generate.pl /usr/#{libdir}/httpd/modules /etc/httpd/mods-available"
    action :run
  end

  ['a2ensite','a2dissite','a2enmod','a2dismod'].each do |modscript|
    template "/usr/sbin/#{modscript}" do
      source "#{modscript}.erb"
      mode 0755
      owner 'root'
      group 'root'
    end
  end

  # installed by default on centos/rhel, remove in favour of mods-enabled
  file "#{node[:apache][:dir]}/conf.d/proxy_ajp.conf" do
    action :delete
    backup false
  end

  file "#{node[:apache][:dir]}/conf.d/README" do
    action :delete
    backup false
  end

  # welcome page moved to the default-site.rb temlate
  file "#{node[:apache][:dir]}/conf.d/welcome.conf" do
    action :delete
    backup false
  end
end

directory "#{node[:apache][:dir]}/ssl" do
  action :create
  mode 0755
  owner 'root'
  group 'root'
end

template 'apache2.conf' do
  case node[:platform]
  when 'centos','redhat','fedora','amazon'
    path "#{node[:apache][:dir]}/conf/httpd.conf"
  when 'debian','ubuntu'
    path "#{node[:apache][:dir]}/apache2.conf"
  end
  source 'apache2.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :run, resources(:execute => 'logdir_existence_and_restart_apache2')
end

template 'security' do
  path "#{node[:apache][:dir]}/conf.d/security"
  source 'security.erb'
  owner 'root'
  group 'root'
  mode 0644
  backup false
  notifies :run, resources(:execute => 'logdir_existence_and_restart_apache2')
end

template 'charset' do
  path "#{node[:apache][:dir]}/conf.d/charset"
  source 'charset.erb'
  owner 'root'
  group 'root'
  mode 0644
  backup false
  notifies :run, resources(:execute => 'logdir_existence_and_restart_apache2')
end

template "#{node[:apache][:dir]}/ports.conf" do
  source 'ports.conf.erb'
  group 'root'
  owner 'root'
  mode 0644
  notifies :run, resources(:execute => 'logdir_existence_and_restart_apache2')
end

template "#{node[:apache][:dir]}/sites-available/default" do
  source 'default-site.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :run, resources(:execute => 'logdir_existence_and_restart_apache2')
end

include_recipe 'apache2::mod_status'
include_recipe 'apache2::mod_headers'
include_recipe 'apache2::mod_alias'
include_recipe 'apache2::mod_auth_basic'
include_recipe 'apache2::mod_authn_file'
include_recipe 'apache2::mod_authz_default'
include_recipe 'apache2::mod_authz_groupfile'
include_recipe 'apache2::mod_authz_host'
include_recipe 'apache2::mod_authz_user'
include_recipe 'apache2::mod_autoindex'
include_recipe 'apache2::mod_dir'
include_recipe 'apache2::mod_env'
include_recipe 'apache2::mod_mime'
include_recipe 'apache2::mod_negotiation'
include_recipe 'apache2::mod_setenvif'
include_recipe 'apache2::mod_log_config' if platform?('centos','redhat','amazon')
include_recipe 'apache2::mod_ssl'
include_recipe 'apache2::mod_expires'
include_recipe 'apache2::logrotate'

# uncomment to get working example site on centos/redhat/fedora/amazon
#apache_site 'default'

execute 'logdir_existence_and_restart_apache2' do
  action :run
end

file "#{node[:apache][:document_root]}/index.html" do
  action :delete
  backup false
  only_if do
    File.exists?("#{node[:apache][:document_root]}/index.html")
  end
end
