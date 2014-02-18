unless node[:opsworks][:skip_uninstall_of_other_rails_stack]
  include_recipe "apache2::uninstall"
end

include_recipe "nginx"
include_recipe "unicorn"

# setup Unicorn service per app
node[:deploy].each do |application, deploy|
  if deploy[:application_server_type] != 'rack' && deploy[:application_type] != 'rails' && deploy[:application_type] != 'sinatra' 
    Chef::Log.debug("Skipping unicorn::rack application #{application} as it is not specified to have a rack server, nor a Rails, nor Sinatra app")
    next
  end

  Chef::Log.debug("[custom-unicorn] Running unicorn::rack for application #{application} with application_server_type: #{deploy[:application_server_type]} and application_type: #{deploy[:application_type]}")
  
  opsworks_deploy_user do
    deploy_data deploy
  end

  opsworks_deploy_dir do
    user    deploy[:user]
    group   deploy[:group]
    path    deploy[:deploy_to]
  end

  template "#{deploy[:deploy_to]}/shared/scripts/unicorn" do
    mode '0755'
    owner deploy[:user]
    group deploy[:group]
    source "unicorn.service.erb"
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
    variables(:deploy => deploy, :application => application)
  end
end
