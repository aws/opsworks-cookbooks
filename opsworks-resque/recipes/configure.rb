#
# Cookbook Name:: opsworks-resque
# Recipe:: default
#
# Copyright (C) 2014 PEDRO AXELRUD
#
# All rights reserved - Do Not Redistribute
#

template "/etc/init/resque.conf" do
  source "resque.conf.erb"
  mode "0755"
end

i = 1
node['resque']['workers'].each do |queue, quantity|
  quantity.times do
    template "/etc/init/resque-#{i}.conf" do
      source "resque-n.conf.erb"
      mode "0755"
      variables queue: queue, instance: i
    end
    i+=1
  end
end
