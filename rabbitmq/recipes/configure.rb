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


# Activating Mnagement-plugin 
Chef::Log.debug "Ativando a interface Administrativa - rabbitmq_management'"
rabbitmq_plugin "rabbitmq_management" do
    action :enable
    notifies :restart, "service[#{node['rabbitmq']['service_name']}]"
end


Chef::Log.info("Creating and Setting all permissions and groups to the user")
# Create User -  access the Management Interface
node.set['rabbitmq']['enabled_users'] =
  [{ :name => 'guest', :password => 'guest', :rights =>
    [{ :vhost => nil, :conf => '.*', :write => '.*', :read => '.*' }]
  },
  { :name => 'rabbit', :password => '123123', :tag => 'administrator', :rights =>
    [{ :vhost => '/', :conf => '.*', :write => '.*', :read => '.*' }]
  }]


# rabbitmq_user "rabbit" do
#   password "123123"
#   action :add
# end

# Chef::Log.info("Configurando as permissões")
# # Set user as Administrator
# rabbitmq_user "rabbit" do
#   tag "administrator"
#   action :set_tags
# end

# rabbitmq_user "rabbit" do
#   vhost '/'
#   permissions ".* .* .*"
#   action :set_permissions
# end


if node['rabbitmq']['cluster']  
  # Layer Name  
  rabbitmq_layer = node['rabbitmq']['opsworks']['layer_name']
  
  # Instances successfully activated
  instances = node[:opsworks][:layers][rabbitmq_layer][:instances]

  # Cluster Name
  node.set['rabbitmq']['clustering']['cluster_name'] = 'rabbit-iv'

  if instances.length > 1 
    Chef::Log.info("Setando os nós do cluster de acordo com as instancias criadas")
    rabbitmq_cluster_nodes = instances.map{|name, attr| {:name=>"rabbit@#{name}",:type=>'disc'} }

    # Cluster Nodes
    node.set['rabbitmq']['cluster_disk_nodes'] = rabbitmq_cluster_nodes
    node.set['rabbitmq']['clustering']['cluster_nodes'] = rabbitmq_cluster_nodes
  end

end

service node['rabbitmq']['service_name'] do
    action [:enable, :start]
end

node.set['rabbitmq']['policies']['ha-all']['pattern'] = '^(?!amq\\.).*'
node.set['rabbitmq']['policies']['ha-all']['params'] = { 'ha-mode' => 'all' }
node.set['rabbitmq']['policies']['ha-all']['priority'] = 0

# # Setting Policies
# Chef::Log.debug "Setando as Policies ha-all:all"
# rabbitmq_policy "ha-all" do
#   pattern "^ha.).*"
#   params ({"ha-mode"=>"all"})
#   priority 1
#   action :set
# end
