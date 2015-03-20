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
    repo node[:deploy][:repositorie]
    user "deploy"
    deploy_to "/opt/legacy_consumers"
    action :deploy
    ssh_wrapper node[:deploy][:ssh_key]
  end
end
