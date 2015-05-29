include_recipe "deploy"

node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  execute "restart Rails app #{application}" do
    cwd deploy[:current_path]
    command node[:opsworks][:rails_stack][:restart_command]
    action :nothing
  end

  node.default[:deploy][application][:database][:adapter] = OpsWorks::RailsConfiguration.determine_database_adapter(application, node[:deploy][application], "#{node[:deploy][application][:deploy_to]}/current", :force => node[:force_database_adapter_detection])
  deploy = node[:deploy][application]

  #Setting default database template
  db_template = "database.yml.erb"

  if !deploy[:environment_variables][:DATABASE_YML_TEMPLATE].blank?
    db_template = deploy[:environment_variables][:DATABASE_YML_TEMPLATE]
  end

  if deploy[:environment_variables][:DEFAULT_DATABASE_HOST]
    db_vars[:host] = deploy[:environment_variables][:DEFAULT_DATABASE_HOST] ? deploy[:environment_variables][:DEFAULT_DATABASE_HOST] : deploy[:database][:host]
    db_vars[:username] = deploy[:environment_variables][:DEFAULT_DATABASE_USERNAME] ? deploy[:environment_variables][:DEFAULT_DATABASE_USERNAME] : deploy[:database][:username]
    db_vars[:password] = deploy[:environment_variables][:DEFAULT_DATABASE_PASSWORD] ? deploy[:environment_variables][:DEFAULT_DATABASE_PASSWORD] : deploy[:database][:password]
  else
    db_vars = deploy[:database]
  end

  template "#{deploy[:deploy_to]}/shared/config/database.yml" do
    source db_template
    cookbook 'rails'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(:database => db_vars, :environment => deploy[:rails_env], :envs => deploy[:environment_variables])

    notifies :run, "execute[restart Rails app #{application}]"

    only_if do
      File.directory?("#{deploy[:deploy_to]}/shared/config/")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/memcached.yml" do
    source "memcached.yml.erb"
    cookbook 'rails'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(
      :memcached => deploy[:memcached] || {},
      :environment => deploy[:rails_env]
    )

    notifies :run, "execute[restart Rails app #{application}]"

    only_if do
      deploy[:memcached][:host].present? && File.directory?("#{deploy[:deploy_to]}/shared/config/")
    end
  end
end