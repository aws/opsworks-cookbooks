#
# Cookbook Name:: opsworks-resque-scheduler
# Recipe:: default
#
# Copyright (C) 2014 PEDRO AXELRUD
#
# All rights reserved - Do Not Redistribute
#

template "/etc/init/resque-scheduler.conf" do
  source "resque-scheduler.conf.erb"
  mode "0755"
end
