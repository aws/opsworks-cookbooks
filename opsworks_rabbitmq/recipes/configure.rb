# Encoding: utf-8
#
# Cookbook Name:: opsworks_rabbitmq
# Recipe:: configure
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

class Chef::Resource # rubocop:disable all
  include Opscode::RabbitMQ # rubocop:enable all
end

# Placeholder service (TODO: Fix in Chef 12)
case node['platform_family']
when 'debian'
  if node['rabbitmq']['job_control'] == 'upstart'
    service node['rabbitmq']['service_name'] do
      provider Chef::Provider::Service::Upstart
      action :nothing
    end
  end

  if node['rabbitmq']['job_control'] == 'initd'
    service node['rabbitmq']['service_name'] do
      supports :status => true, :restart => true
      action :nothing
    end
  end
when 'rhel', 'fedora', 'suse', 'smartos'
  service node['rabbitmq']['service_name'] do
    action :nothing
  end
end

if node['rabbitmq']['logdir']
  directory node['rabbitmq']['logdir'] do
    owner 'rabbitmq'
    group 'rabbitmq'
    mode '775'
    recursive true
  end
end

directory node['rabbitmq']['mnesiadir'] do
  owner 'rabbitmq'
  group 'rabbitmq'
  mode '775'
  recursive true
end

template "#{node['rabbitmq']['config_root']}/rabbitmq-env.conf" do
  source 'rabbitmq-env.conf.erb'
  cookbook 'rabbitmq'
  owner 'root'
  group 'root'
  mode 00644
  notifies :restart, "service[#{node['rabbitmq']['service_name']}]", :immediately
end

template "#{node['rabbitmq']['config']}.config" do
  sensitive true
  source 'rabbitmq.config.erb'
  cookbook node['rabbitmq']['config_template_cookbook']
  owner 'root'
  group 'root'
  mode 00644
  variables(
    :kernel => format_kernel_parameters
  )
  notifies :restart, "service[#{node['rabbitmq']['service_name']}]", :immediately
end

if File.exist?(node['rabbitmq']['erlang_cookie_path']) && File.readable?((node['rabbitmq']['erlang_cookie_path']))
  existing_erlang_key =  File.read(node['rabbitmq']['erlang_cookie_path']).strip
else
  existing_erlang_key = ''
end

if node['rabbitmq']['cluster'] && (node['rabbitmq']['erlang_cookie'] != existing_erlang_key)
  include_recipe 'opsworks_rabbitmq::cluster'

  log "stop #{node['rabbitmq']['serice_name']} to change erlang cookie" do
    notifies :stop, "service[#{node['rabbitmq']['service_name']}]", :immediately
  end

  template node['rabbitmq']['erlang_cookie_path'] do
    source 'doterlang.cookie.erb'
    cookbook 'rabbitmq'
    owner 'rabbitmq'
    group 'rabbitmq'
    mode 00400
    notifies :start, "service[#{node['rabbitmq']['service_name']}]", :immediately
    notifies :run, 'execute[reset-node]', :immediately
  end

  # Need to reset for clustering #
  execute 'reset-node' do
    command 'rabbitmqctl stop_app && rabbitmqctl reset && rabbitmqctl start_app'
    action :nothing
  end
end
