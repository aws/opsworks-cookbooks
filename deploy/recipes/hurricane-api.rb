include_recipe 'deploy'
Chef::Log.level = :debug

node[:deploy].each do |application, deploy|

  rails_env = deploy[:rails_env]
  current_path = deploy[:current_path]

  execute "updating crontab" do
    user deploy[:user]
    cwd "#{deploy[:deploy_to]}/current"
    command "bundle exec whenever -w -s environment=#{rails_env}"
    action :run
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


  execute "create environments directory in shared/config" do
    command "mkdir -p #{deploy[:deploy_to]}/shared/config/environments/"
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



  execute "create initializiers directory in shared/config" do
    command "mkdir -p #{deploy[:deploy_to]}/shared/config/initializers/"
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

  execute "create initializiers directory in app/views/shared" do
    command "mkdir -p #{deploy[:deploy_to]}/shared/app/views/shared/"
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
