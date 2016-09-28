#
# Cookbook Name:: mongodb
# Definition:: mongodb
#
# Copyright 2011, edelight GmbH
# Authors:
#       Markus Korn <markus.korn@edelight.de>
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

define :mongodb_instance, :mongodb_type => "mongod" , :action => [:enable, :start],
    :bind_ip => nil, :port => 27017 , :logpath => "/log", :journalpath => "/data/journal",
    :dbpath => "/data", :configfile => "/etc/mongod.conf", :configserver => [],
    :replicaset => nil, :enable_rest => true, :notifies => [] do
    
  include_recipe "mongodb::default"
  
  name = params[:name]
  type = params[:mongodb_type]
  service_action = params[:action]
  service_notifies = params[:notifies]
  
  bind_ip = params[:bind_ip]
  port = params[:port]

  logpath = params[:logpath]
  logfile = "#{logpath}/#{name}.log"
  
  dbpath = params[:dbpath]
  
  journalpath = params[:journalpath]
        
  configfile = params[:configfile]
  configserver_nodes = params[:configserver]
  
  replicaset = params[:replicaset]
  if type == "shard"
    if replicaset.nil?
      replicaset_name = nil
    else
      # for replicated shards we autogenerate the replicaset name for each shard
      replicaset_name = "rs_#{replicaset['mongodb']['shard_name']}"
    end
  else
    # if there is a predefined replicaset name we use it,
    # otherwise we try to generate one using 'rs_$SHARD_NAME'
    begin
      replicaset_name = replicaset['mongodb']['replicaset_name']
    rescue
      replicaset_name = nil
    end
    if replicaset_name.nil?
      begin
        replicaset_name = "rs_#{replicaset['mongodb']['shard_name']}"
      rescue
        replicaset_name = nil
      end
    end
  end
  
  if !["mongod", "shard", "configserver", "mongos"].include?(type)
    raise "Unknown mongodb type '#{type}'"
  end
  
  if type != "mongos"
    daemon = "/usr/bin/mongod"
    configserver = nil
    configfile = nil
  else
    daemon = "/usr/bin/mongos"
    configfile = nil
    dbpath = nil
    configserver = configserver_nodes.collect{|n| "#{n['fqdn']}:#{n['mongodb']['port']}" }.join(",")
  end
  
  # journal link [make sure it exists]
  execute "" do
    command "sudo ln -s #{journalpath} #{dbpath}/journal"
    action :nothing
  end
  
  # chown the mongo directories/volumes per 10gen instructions
  execute "" do
    command "chown mongod:mongod #{journalpath} #{dbpath} #{logpath}"
    action :nothing
  end
  
  # service
  service name do
    supports :status => true, :restart => true
    action :nothing
  end
  
  # default file
  template "#{node['mongodb']['defaults_dir']}/#{name}" do
    action :create
    source "mongodb.default.erb"
    group node['mongodb']['root_group']
    owner "root"
    mode "0644"
    variables(
      "daemon_path" => daemon,
      "name" => name,
      "config" => configfile,
      "configdb" => configserver,
      "bind_ip" => bind_ip,
      "port" => port,
      "logpath" => logfile,
      "dbpath" => dbpath,
      "journalpath" => journalpath,
      "replicaset_name" => replicaset_name,
      "configsrv" => false, #type == "configserver", this might change the port
      "shardsrv" => false,  #type == "shard", dito.
      "enable_rest" => params[:enable_rest]
    )
    notifies :restart, resources(:service => name)
  end
  
  # config file
  template "/etc/mongod.conf" do
    action :create
    source "mongodb.amazon.erb"
    group node['mongodb']['root_group']
    owner "root"
    mode "0644"
    variables(
      "daemon_path" => daemon,
      "name" => name,
      "config" => configfile,
      "configdb" => configserver,
      "bind_ip" => bind_ip,
      "port" => port,
      "logpath" => logfile,
      "dbpath" => dbpath,
      "journalpath" => journalpath,
      "replicaset_name" => replicaset_name,
      "configsrv" => false, #type == "configserver", this might change the port
      "shardsrv" => false,  #type == "shard", dito.
      "enable_rest" => params[:enable_rest]
    )
    notifies :restart, resources(:service => name)
  end
  
  # log dir [make sure it exists]
  directory logpath do
    owner node[:mongodb][:user]
    group node[:mongodb][:group]
    mode "0755"
    action :create
    recursive true
  end
      
  if type != "mongos"
    # dbpath dir [make sure it exists]
    directory dbpath do
      owner node[:mongodb][:user]
      group node[:mongodb][:group]
      mode "0755"
      action :create
      recursive true
    end
  end
  
  # init script
  template "#{node['mongodb']['init_dir']}/#{name}" do
    action :create
    source node[:mongodb][:init_script_template]
    group node['mongodb']['root_group']
    owner "root"
    mode "0755"
    variables :provides => name
    notifies :restart, resources(:service => name)
  end
   
  # service
  service name do
    action service_action
    service_notifies.each do |service_notify|
      notifies :run, service_notify
    end
    if !replicaset_name.nil? && node['mongodb']['auto_configure']['replicaset']
      notifies :create, "ruby_block[config_replicaset]"
    end
    if type == "mongos" && node['mongodb']['auto_configure']['sharding']
      notifies :create, "ruby_block[config_sharding]", :immediately
    end
    if name == "mongodb"
      # we don't care about a running mongodb service in these cases, all we need is stopping it
      ignore_failure true
    end
  end
  
  # replicaset
  if !replicaset_name.nil? && node['mongodb']['auto_configure']['replicaset']
    rs_nodes = search(
      :node,
      "mongodb_cluster_name:#{replicaset['mongodb']['cluster_name']} AND \
       recipes:mongodb\\:\\:replicaset AND \
       mongodb_shard_name:#{replicaset['mongodb']['shard_name']} AND \
       chef_environment:#{replicaset.chef_environment}"
    )
  
    ruby_block "config_replicaset" do
      block do
        if not replicaset.nil?
          MongoDB.configure_replicaset(replicaset, replicaset_name, rs_nodes)
        end
      end
      action :nothing
    end
  end
  
  # sharding
  if type == "mongos" && node['mongodb']['auto_configure']['sharding']
    # add all shards
    # configure the sharded collections
    
    shard_nodes = search(
      :node,
      "mongodb_cluster_name:#{node['mongodb']['cluster_name']} AND \
       recipes:mongodb\\:\\:shard AND \
       chef_environment:#{node.chef_environment}"
    )
    
    ruby_block "config_sharding" do
      block do
        if type == "mongos"
          MongoDB.configure_shards(node, shard_nodes)
          MongoDB.configure_sharded_collections(node, node['mongodb']['sharded_collections'])
        end
      end
      action :nothing
    end
  end
end

