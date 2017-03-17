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

Chef::Log.info("Creating and Setting all permissions and groups to the user")
# Create User -  access the Management Interface

if node['rabbitmq']['cluster']
  # Layer Name  
  rabbitmq_layer = node['rabbitmq']['opsworks']['layer_name']
  
  # Cluster Name
  node.set['rabbitmq']['clustering']['cluster_name'] = 'rabbit'

  node.set['rabbitmq']['enabled_users'] =
      [{ :name => 'guest', :password => 'guest', :rights =>
          [{ :vhost => nil, :conf => '.*', :write => '.*', :read => '.*' }]
       },
       { :name => "#{node['rabbitmq']['admin_username']}", :password => "#{node['rabbitmq']['custom_pass']}", :tag => 'administrator', :rights =>
           [{ :vhost => '/', :conf => '.*', :write => '.*', :read => '.*' }]
       }]

  begin
    # Instances successfully activated
    instances = node[:opsworks][:layers][rabbitmq_layer][:instances]

    Chef::Log.info("Setando os nós do cluster de acordo com as instancias criadas")
    rabbitmq_cluster_nodes = instances.map{|name, attr| {:name=>"rabbit@#{name}",:type=>'disc'} }

    # Cluster Nodes
    node.set['rabbitmq']['cluster_disk_nodes'] = rabbitmq_cluster_nodes
    node.set['rabbitmq']['clustering']['cluster_nodes'] = rabbitmq_cluster_nodes
  rescue
    Chef::Log.info("Primeiro Nó ")
  end

end

# Activating Mnagement-plugin 
Chef::Log.debug "Ativando a interface Administrativa - rabbitmq_management'"
rabbitmq_plugin "rabbitmq_management" do
  action :enable
  #notifies :restart, "service[#{node['rabbitmq']['service_name']}]"
end

service node['rabbitmq']['service_name'] do
  action [:enable, :start]
end

# Dead Letter Exchange and Queue declaration
def queue_exists?(name, credentials)
  command = "rabbitmqadmin #{credentials} list queues | grep #{name}"
  command = Mixlib::ShellOut.new(command)
  command.run_command
  begin
    command.error!
    true
  rescue
    false
  end
end

def exchange_exists?(name, credentials)
  command = "rabbitmqadmin #{credentials} list exchanges | grep #{name}"
  command = Mixlib::ShellOut.new(command)
  command.run_command
  begin
    command.error!
    true
  rescue
    false
  end
end

queue_name = node["rabbitmq"]["dead_letter_queue_name"]
exchange_name = node["rabbitmq"]["dead_letter_exchange_name"]
credentials = "-u #{node["rabbitmq"]["admin_username"]} -p #{node['rabbitmq']['custom_pass']}"
Chef::Log.info("Credentials created: #{credentials}")

node.set['rabbitmq']['policies']['ha-all']['pattern'] = ''
node.set['rabbitmq']['policies']['ha-all']['params'] = { 'ha-mode' => 'all', 'dead-letter-exchange' => "#{exchange_name}" }
node.set['rabbitmq']['policies']['ha-all']['priority'] = 0


Chef::Log.info("Dead Letter Exchange and Queue declaration begin")

if not queue_exists?(queue_name, credentials)
  execute "create_dead_letter_queue" do
    command "rabbitmqadmin #{credentials} declare queue name=#{queue_name} durable=true"
    Chef::Log.info("Declared queue name=#{queue_name}")
  end
end

if not exchange_exists?(exchange_name,credentials)

  execute 'create_dead_letter_exchange' do
    command "rabbitmqadmin #{credentials} declare exchange name=#{exchange_name} type=fanout"
    Chef::Log.info("Declared exchange name=#{exchange_name}")
  end

  execute "create_dead_letter_bindings" do
    command "rabbitmqadmin #{credentials} declare binding source=#{exchange_name} destination_type=queue destination=#{queue_name}"
    Chef::Log.info("Declared the binding between source=#{exchange_name} and destination=#{queue_name}")
  end

  # We need to 'initialize' the exchange in order to make DLX to work
  execute "send_an_initialization_message_to_DLX" do
    Chef::Log.info("Sending initialization message to the exchange")
    command "rabbitmqadmin #{credentials} publish exchange=#{exchange_name} payload='initialization_message' routing_key='/test/'"
  end

  execute "get_the_initialization_message" do
    command "rabbitmqadmin #{credentials} get queue=#{queue_name} requeue=false"
    Chef::Log.info("Got initialization message from the DLX queue=#{queue_name}")
  end
end

Chef::Log.info("SUCCESS. Dead Letter Exchange and Queue declaration ended")

