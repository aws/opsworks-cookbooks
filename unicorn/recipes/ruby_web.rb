include_recipe "nginx"
include_recipe "unicorn"

# setup Unicorn service per app
node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'other'
    Chef::Log.debug("Skipping unicorn::ruby_web application #{application} as it is not an Ruby Web app")
    next
  end

  opsworks_deploy_user do
    deploy_data deploy
  end

  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  template "#{deploy[:deploy_to]}/shared/scripts/unicorn" do
    mode '0755'
    owner deploy[:user]
    group deploy[:group]
    source "unicorn.service.ruby_web.erb"
    variables(:deploy => deploy, :application => application)
  end

  service "unicorn_#{application}" do
    start_command "#{deploy[:deploy_to]}/shared/scripts/unicorn start"
    stop_command "#{deploy[:deploy_to]}/shared/scripts/unicorn stop"
    restart_command "#{deploy[:deploy_to]}/shared/scripts/unicorn restart"
    status_command "#{deploy[:deploy_to]}/shared/scripts/unicorn status"
    action :nothing
  end

  template "#{deploy[:deploy_to]}/shared/config/unicorn.conf" do
    mode '0644'
    owner deploy[:user]
    group deploy[:group]
    source "unicorn.conf.erb"
    variables(
      :deploy => deploy,
      :application => application,
      :environment => OpsWorks::Escape.escape_double_quotes(deploy[:environment_variables])
    )
  end
end
