include_recipe "deploy"

node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

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

  template "#{deploy[:deploy_to]}/shared/config/config.yml" do
    source "config.yml.erb"
    cookbook 'mpdx'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(:config => deploy[:config], :environment => deploy[:rails_env])
  end

  template "#{deploy[:deploy_to]}/shared/config/redis.yml" do
    source "redis.yml.erb"
    cookbook 'mpdx'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(:redis => deploy[:redis] || {}, :environment => deploy[:rails_env])
  end

  template "#{deploy[:deploy_to]}/shared/config/sidekiq.yml" do
    source "sidekiq.yml.erb"
    cookbook 'mpdx'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(:sidekiq => deploy[:sidekiq] || {}, :environment => deploy[:rails_env])
  end
end
