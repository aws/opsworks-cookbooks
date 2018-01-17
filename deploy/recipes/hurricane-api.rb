include_recipe 'deploy'
Chef::Log.level = :debug


node[:deploy].each do |application, deploy|

  rails_env = deploy[:rails_env]
  current_path = deploy[:current_path]

  directory "#{deploy[:deploy_to]}/shared/config/initializers" do
    mode '0770'
    owner deploy[:user]
    group deploy[:group]
    action :create
    recursive true
  end

  directory "#{deploy[:deploy_to]}/shared/app/views/shared" do
    mode '0770'
    owner deploy[:user]
    group deploy[:group]
    action :create
    recursive true
  end

  directory "#{deploy[:deploy_to]}/shared/config/environments" do
    mode '0770'
    owner deploy[:user]
    group deploy[:group]
    action :create
    recursive true
  end

  template "#{deploy[:deploy_to]}/shared/config/secrets.yml" do
    source 'hurricane-api/secrets.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :hurricane_api_settings => node[:hurricane_api_settings]
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/slimpay.yml" do
    source 'hurricane-api/slimpay.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :hurricane_api_settings => node[:hurricane_api_settings],
        :env => rails_env
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/email_checker.yml" do
    source 'hurricane-api/email_checker.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :hurricane_api_settings => node[:hurricane_api_settings],
        :env => rails_env
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/signature_features.yml" do
    source 'hurricane-api/signature_features.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :hurricane_api_settings => node[:hurricane_api_settings],
        :env => rails_env
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/initializers/docusign_rest.rb" do
    source 'hurricane-api/docusign_rest.rb.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(:hurricane_api_settings => node[:hurricane_api_settings])
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config/initializers")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/twilio.yml" do
    source 'hurricane-api/twilio.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :hurricane_api_settings => node[:hurricane_api_settings],
        :env => rails_env
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/infocar.yml" do
    source 'hurricane-api/infocar.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :hurricane_api_settings => node[:hurricane_api_settings],
        :env => rails_env
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/remote_counter.yml" do
    source 'hurricane-api/remote_counter.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :hurricane_api_settings => node[:hurricane_api_settings],
        :env => rails_env
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/environments/#{rails_env}.rb" do
    source "hurricane-api/environment_config.rb.erb"
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :hurricane_api_settings => node[:hurricane_api_settings]
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config/environments")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/initializers/rollbar.rb" do
    source 'hurricane-api/rollbar.rb.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :hurricane_api_settings => node[:hurricane_api_settings]
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config/initializers")
    end
  end


  execute "remove crontab" do
    user deploy[:user]
    cwd "#{deploy[:deploy_to]}/current"
    command "bundle exec whenever -c #{deploy[:deploy_to]}/current/schedule.rb"
    action :run
  end

  execute "restart Server" do
    Chef::Log.debug('Restarting Rails Server From Hurricane Script')
    cwd deploy[:current_path]
    command "sleep #{deploy[:sleep_before_restart]} && #{node[:opsworks][:rails_stack][:restart_command]}"
    action :run

    only_if do
      File.exists?(deploy[:current_path])
    end
  end

end

if node[:hurricane_api_settings][:deploy_whenever] == true

  node[:deploy].first(1).each do |application, deploy|

    rails_env = deploy[:rails_env]
    current_path = deploy[:current_path]

    execute "updating crontab" do
      user deploy[:user]
      cwd "#{deploy[:deploy_to]}/current"
      command "bundle exec whenever -w -s environment=#{rails_env}"
      action :run
    end

  end


end



