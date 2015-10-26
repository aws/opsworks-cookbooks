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
  case node[:platform_family]
  when 'rhel'
    package_name 'httpd'
  when 'debian'
    package_name 'apache2'
  end
  action :install
end

include_recipe 'apache2::service'

service 'apache2' do
  service_name value_for_platform_family(
    'rhel' => 'httpd',
    'debian' => 'apache2'
  )
  action :enable
end

if platform_family?('debian')
  execute "reset permission of #{node[:apache][:log_dir]}" do
    command "chmod 0755 #{node[:apache][:log_dir]}"
  end
end

bash 'logdir_existence_and_restart_apache2' do
  code <<-EOF
    until
      ls -la #{node[:apache][:log_dir]}
    do
      echo "Waiting for #{node[:apache][:log_dir]}..."
      sleep 1
    done
  EOF
  action :nothing
  notifies :restart, resources(:service => 'apache2')
  timeout 70
end

if platform_family?('rhel')
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

  conf_dir = node[:apache][:conf_enabled_dir] || "#{node[:apache][:dir]}/conf.d"

  # installed by default on centos/rhel, remove in favour of mods-enabled
  file "#{conf_dir}/proxy_ajp.conf" do
    action :delete
    backup false
  end

  file "#{conf_dir}/README" do
    action :delete
    backup false
  end

  # welcome page moved to the default-site.rb temlate
  file "#{conf_dir}/welcome.conf" do
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

template "#{node[:apache][:dir]}/envvars" do
  source 'envvars.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :run, resources(:bash => 'logdir_existence_and_restart_apache2')
  only_if { platform?('ubuntu') && node[:platform_version] == '14.04' }
end

template 'apache2.conf' do
  case node[:platform_family]
  when 'rhel'
    path "#{node[:apache][:dir]}/conf/httpd.conf"
  when 'debian'
    path "#{node[:apache][:dir]}/apache2.conf"
  end
  source 'apache2.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :run, resources(:bash => 'logdir_existence_and_restart_apache2')
end

if platform?('ubuntu') && node[:platform_version] == '14.04'
  execute 'disable config for serve-cgi-bin' do
    command '/usr/sbin/a2disconf serve-cgi-bin'
    user 'root'
  end

  template "#{node[:apache][:dir]}/ports.conf" do
    source "ports.conf.erb"
    owner 'root'
    group 'root'
    mode 0644
    backup false
  end

  ['security', 'charset'].each do |config|
    template "#{node[:apache][:conf_available_dir]}/#{config}.conf" do
      source "#{config}.conf.erb"
      owner 'root'
      group 'root'
      mode 0644
      backup false
    end

    execute "enable config #{config}" do
      command "/usr/sbin/a2enconf #{config}"
      user 'root'
      notifies :run, resources(:bash => 'logdir_existence_and_restart_apache2')
    end
  end
else
  template 'security' do
    path "#{node[:apache][:dir]}/conf.d/security"
    source 'security.erb'
    owner 'root'
    group 'root'
    mode 0644
    backup false
    notifies :run, resources(:bash => 'logdir_existence_and_restart_apache2')
  end

  template 'charset' do
    path "#{node[:apache][:dir]}/conf.d/charset"
    source 'charset.erb'
    owner 'root'
    group 'root'
    mode 0644
    backup false
    notifies :run, resources(:bash => 'logdir_existence_and_restart_apache2')
  end

  template "#{node[:apache][:dir]}/ports.conf" do
    source 'ports.conf.erb'
    group 'root'
    owner 'root'
    mode 0644
    notifies :run, resources(:bash => 'logdir_existence_and_restart_apache2')
  end
end

if platform?('ubuntu') && node[:platform_version] == '14.04'
  default_site_config = "#{node[:apache][:dir]}/sites-available/000-default.conf"
else
  default_site_config = "#{node[:apache][:dir]}/sites-available/default"
end
template default_site_config do
  source 'default-site.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :run, resources(:bash => 'logdir_existence_and_restart_apache2')
end

include_recipe 'apache2::mod_status'
include_recipe 'apache2::mod_headers'
include_recipe 'apache2::mod_alias'
include_recipe 'apache2::mod_auth_basic'
include_recipe 'apache2::mod_authn_file'
include_recipe 'apache2::mod_authz_default' if node[:apache][:version] == '2.2'
include_recipe 'apache2::mod_authz_groupfile'
include_recipe 'apache2::mod_authz_host'
include_recipe 'apache2::mod_authz_user'
include_recipe 'apache2::mod_autoindex'
include_recipe 'apache2::mod_dir'
include_recipe 'apache2::mod_env'
include_recipe 'apache2::mod_mime'
include_recipe 'apache2::mod_negotiation'
include_recipe 'apache2::mod_setenvif'
include_recipe 'apache2::mod_log_config' if platform_family?('rhel')
include_recipe 'apache2::mod_ssl'
include_recipe 'apache2::mod_expires'
include_recipe 'apache2::logrotate'

bash 'logdir_existence_and_restart_apache2' do
  action :run
end

file "#{node[:apache][:document_root]}/index.html" do
  action :delete
  backup false
  only_if do
    File.exists?("#{node[:apache][:document_root]}/index.html")
  end
end
