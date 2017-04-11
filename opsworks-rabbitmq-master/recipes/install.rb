# Encoding: utf-8
#
# Cookbook Name:: opsworks_rabbitmq
# Recipe:: install
#
# Copyright (c) 2015, Verdigris Technologies Inc
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
# list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

include_recipe 'erlang'

## Install the package
case node['platform_family']
when 'debian'
  # logrotate is a package dependency of rabbitmq-server
  package 'logrotate'

  if node['rabbitmq']['use_distro_version']
    package 'rabbitmq-server' do
      action :install
      version node['rabbitmq']['version']
    end
  else
    # we need to download the package
    deb_package = "https://www.rabbitmq.com/releases/rabbitmq-server/v#{node['rabbitmq']['version']}/rabbitmq-server_#{node['rabbitmq']['version']}-1_all.deb"
    remote_file "#{Chef::Config[:file_cache_path]}/rabbitmq-server_#{node['rabbitmq']['version']}-1_all.deb" do
      source deb_package
      action :create_if_missing
    end
    dpkg_package "#{Chef::Config[:file_cache_path]}/rabbitmq-server_#{node['rabbitmq']['version']}-1_all.deb" do
      action :install
    end
  end

  # Configure job control
  if node['rabbitmq']['job_control'] == 'upstart'
    # We start with stock init.d, remove it if we're not using init.d, otherwise leave it alone
    service node['rabbitmq']['service_name'] do
      action [:stop]
      only_if { File.exist?('/etc/init.d/rabbitmq-server') }
    end

    execute 'remove rabbitmq init.d command' do
      command 'update-rc.d -f rabbitmq-server remove'
    end

    file '/etc/init.d/rabbitmq-server' do
      action :delete
    end

    template "/etc/init/#{node['rabbitmq']['service_name']}.conf" do
      source 'rabbitmq.upstart.conf.erb'
      cookbook 'rabbitmq'
      owner 'root'
      group 'root'
      mode 0644
      variables(:max_file_descriptors => node['rabbitmq']['max_file_descriptors'])
    end

    service node['rabbitmq']['service_name'] do
      provider Chef::Provider::Service::Upstart
      action [:enable, :start]
      # restart_command "stop #{node['rabbitmq']['service_name']} && start #{node['rabbitmq']['service_name']}"
    end
  end

  if node['rabbitmq']['job_control'] == 'initd'
    service node['rabbitmq']['service_name'] do
      supports :status => true, :restart => true
      action [:enable, :start]
    end
  end

when 'rhel', 'fedora'
  # This is needed since Erlang Solutions' packages provide "esl-erlang"; this package just requires "esl-erlang" and provides "erlang".
  if node['erlang']['install_method'] == 'esl'
    remote_file "#{Chef::Config[:file_cache_path]}/esl-erlang-compat.rpm" do
      source 'https://github.com/jasonmcintosh/esl-erlang-compat/blob/master/rpmbuild/RPMS/noarch/esl-erlang-compat-R14B-1.el6.noarch.rpm?raw=true'
    end
    rpm_package "#{Chef::Config[:file_cache_path]}/esl-erlang-compat.rpm"
  end

  if node['rabbitmq']['use_distro_version']
    package 'rabbitmq-server' do
      action :install
      version node['rabbitmq']['version']
    end
  else
    # We need to download the rpm
    rpm_package = "https://www.rabbitmq.com/releases/rabbitmq-server/v#{node['rabbitmq']['version']}/rabbitmq-server-#{node['rabbitmq']['version']}-1.noarch.rpm"

    remote_file "#{Chef::Config[:file_cache_path]}/rabbitmq-server-#{node['rabbitmq']['version']}-1.noarch.rpm" do
      source rpm_package
      action :create_if_missing
    end
    rpm_package "#{Chef::Config[:file_cache_path]}/rabbitmq-server-#{node['rabbitmq']['version']}-1.noarch.rpm"
  end

  service node['rabbitmq']['service_name'] do
    action [:enable, :start]
  end

when 'suse'
  # rabbitmq-server-plugins needs to be first so they both get installed
  # from the right repository. Otherwise, zypper will stop and ask for a
  # vendor change.
  package 'rabbitmq-server-plugins' do
    action :install
    version node['rabbitmq']['version']
  end
  package 'rabbitmq-server' do
    action :install
    version node['rabbitmq']['version']
  end

  service node['rabbitmq']['service_name'] do
    action [:enable, :start]
  end
when 'smartos'
  package 'rabbitmq'do
    action :install
    version node['rabbitmq']['version']
  end

  service 'epmd' do
    action :start
  end

  service node['rabbitmq']['service_name'] do
    action [:enable, :start]
  end
end
