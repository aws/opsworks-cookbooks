include_recipe "deploy"

node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  execute "restart Rails app #{application}" do
    cwd deploy[:current_path]
    command node[:opsworks][:rails_stack][:restart_command]
    action :nothing
  end

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

    notifies :run, "execute[restart Rails app #{application}]"
  end

end
