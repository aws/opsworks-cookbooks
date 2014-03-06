unless node[:opsworks][:skip_uninstall_of_other_rails_stack]
  include_recipe "apache2::uninstall"
end

include_recipe 'nginx'
include_recipe 'puma'

# setup Unicorn service per app
node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'rails'
    Chef::Log.debug("Skipping puma::rails application #{application} as it is not an Rails app")
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

  template "#{deploy[:deploy_to]}/shared/scripts/puma" do
    mode '0755'
    owner deploy[:user]
    group deploy[:group]
    source 'puma.service.erb'
    variables(:deploy => deploy, :application => application)
  end

  service "puma_#{application}" do
    start_command "#{deploy[:deploy_to]}/shared/scripts/puma start"
    stop_command "#{deploy[:deploy_to]}/shared/scripts/puma stop"
    restart_command "#{deploy[:deploy_to]}/shared/scripts/puma restart"
    status_command "#{deploy[:deploy_to]}/shared/scripts/puma status"
    action :nothing
  end

  template "#{deploy[:deploy_to]}/shared/config/puma.conf" do
    mode '0644'
    owner deploy[:user]
    group deploy[:group]
    source 'puma.conf.erb'
    variables(:deploy => deploy, :application => application)
  end
end
