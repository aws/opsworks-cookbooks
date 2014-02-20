include_recipe "deploy"
include_recipe "rails::configure"

deploy = node[:deploy][:global_registry]

directory "#{deploy[:deploy_to]}" do
  action :create
  recursive true
  mode "0770"
  group deploy[:group]
  owner deploy[:user]
end


directory "#{deploy[:deploy_to]}/shared" do
  action :create
  recursive true
  mode "0770"
  group deploy[:group]
  owner deploy[:user]
end

directory "#{deploy[:deploy_to]}/shared/config" do
  action :create
  recursive true
  mode "0770"
  group deploy[:group]
  owner deploy[:user]
end

template "#{deploy[:deploy_to]}/shared/config/settings.local.yml" do
  source "settings.local.yml.erb"
  cookbook 'mpdx'
  mode "0660"
  group deploy[:group]
  owner deploy[:user]
  variables(:secrets => deploy[:secrets], :environment => deploy[:rails_env])
end
