#
# Cookbook Name:: opsworks-resque
# Recipe:: default
#
# Copyright (C) 2014 PEDRO AXELRUD
#
# All rights reserved - Do Not Redistribute
#

node[:deploy].each do |application, deploy|

  Chef::Log.info("Configuring resque for application #{application}")

  execute 'remove queues' do
    command 'rm /etc/init/resque-*'
  end

  template "/etc/init/resque-#{application}.conf" do
    source "resque.conf.erb"
    mode '0644'
    variables deploy: deploy
  end

  settings = node[:resque][application]
  # configure rails_env in case of non-rails app
  rack_env = deploy[:rails_env] || settings[:rack_env] || settings[:rails_env]

  template "/etc/init/resque-#{application}-scheduler.conf" do
    source "resque-scheduler.conf.erb"
    mode '0644'
    variables application: application, rack_env: rack_env, deploy: deploy
  end
  
  settings[:workers].each do |queue, quantity|
    queue_name = queue == '*' ? 'asterisk' : queue

    quantity.times do |idx|
      idx = idx + 1 # make index 1-based
      template "/etc/init/resque-#{application}-#{queue_name}-#{idx}.conf" do
        source "resque-n.conf.erb"
        mode '0644'
        variables application: application, rack_env: rack_env, deploy: deploy, queue: queue, queue_name: queue_name, instance: idx
      end
    end
  end

  directory '/var/log/resque' do
    owner deploy[:user]
    group deploy[:group]
    mode '755'
    action :create
    recursive true
  end

end
