#
# Cookbook Name:: deploy
# Recipe:: rails
#

include_recipe "rails"

node[:deploy].each do |application, deploy|
  scalarium_deploy_user do
    deploy_data deploy
    app application
  end

  scalarium_rails do
    deploy_data deploy
    app application
  end

  scalarium_deploy do
    deploy_data deploy
    app application
  end
end

