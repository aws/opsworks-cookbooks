include_recipe "deploy"
#include_recipe "nginx:stop"
#include_recipe "unicorn:stop"

node[:deploy].each do |application, deploy|
  bluepill = deploy[:bluepill] || {}

  resque_config application do
    path deploy[:deploy_to]
    owner deploy[:user]
    group deploy[:group]
    bundler true
    envs bluepill[:envs]
  end

  execute "load bluepill file for #{application}" do
    cwd deploy[:current_path]
    command "bundle exec bluepill load #{deploy[:deploy_to]}/shared/resque.pill"
    action :run
  end

  execute "restart resque for #{application}" do
    cwd deploy[:current_path]
    command "bundle exec bluepill restart resque"
    action :run
  end

end
