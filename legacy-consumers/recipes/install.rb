#
# Cookbook Name:: legacy-consumer
# Recipe:: install
#
# Copyright 2015, Estante Virtual
#
# All rights reserved - Do Not Redistribute
#



node[:deploy].each do |app_name, deploy|
  deploy "legacy_consumers" do
    repo node[:deploy][app_name][:repositorie]
    user "deploy"
    deploy_to "/opt/legacy_consumers"
    action :deploy
    ssh_wrapper node[:deploy][app_name][:ssh_key]
  end
end
