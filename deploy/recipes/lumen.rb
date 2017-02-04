include_recipe 'deploy'
Chef::Log.level = :debug

node[:deploy].each do |application, deploy|

  rails_env = deploy[:rails_env]
  current_path = deploy[:current_path]

  active_job_with_resque = (node[:lumen_settings][:active_job].present? && node[:lumen_settings][:active_job][:adapter] == 'resque')

  execute "create routes directory in shared/config" do
    command "mkdir -p #{deploy[:deploy_to]}/shared/config/routes/"
  end


  template "#{deploy[:deploy_to]}/shared/config/resque.yml" do
    source 'lumen/config/resque.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :lumen_settings => node[:lumen_settings],
        :lumen_env => rails_env
    )
    only_if do
      active_job_with_resque && File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/routes/resque_server.erb" do
    source 'lumen/config/routes/resque_server.rb.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(:lumen_settings => node[:lumen_settings])
    only_if do
      active_job_with_resque && File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/secrets.yml" do
    source 'lumen/config/secrets.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(:lumen_settings => node[:lumen_settings])
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/database.yml" do
    source 'lumen/config/database.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(:lumen_env => rails_env)
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/mailer.yml" do
    source 'lumen/config/mailer.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(:lumen_settings => node[:lumen_settings])
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/aws.yml" do
    source 'lumen/config/aws.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(:lumen_settings => node[:lumen_settings])
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  execute "create environments directory in shared/config" do
    command "mkdir -p #{deploy[:deploy_to]}/shared/config/environments/"
  end

  template "#{deploy[:deploy_to]}/shared/config/environments/#{rails_env}.rb" do
    source 'lumen/config/environments/environment_config.rb.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(:lumen_settings => node[:lumen_settings])
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config/environments")
    end
  end

  execute "create initializiers directory in shared/config" do
    command "mkdir -p #{deploy[:deploy_to]}/shared/config/initializers/"
  end

  template "#{deploy[:deploy_to]}/shared/config/initializers/rollbar.rb" do
    source 'lumen/config/initializers/rollbar.rb.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(:lumen_settings => node[:lumen_settings])
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config/initializers")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/initializers/docusign_rest.rb" do
    source 'lumen/config/initializers/docusign_rest.rb.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(:lumen_settings => node[:lumen_settings])
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config/initializers")
    end
  end

  execute "create initializiers directory in app/views/shared" do
    command "mkdir -p #{deploy[:deploy_to]}/shared/app/views/shared/"
  end

  template "#{deploy[:deploy_to]}/shared/app/views/shared/_rollbar.js.erb" do
    source 'lumen/_rollbar.js.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :lumen_settings => node[:lumen_settings],
        :lumen_env => rails_env
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/app/views/shared")
    end
  end

if active_job_with_resque

    execute 'stop_resque' do
      Chef::Log.info("Stopping Resque....")
      cwd current_path
      user 'deploy'
      command 'bin/bundle exec rake resque:stop'
      environment 'RAILS_ENV' => rails_env
      ignore_failure true
      notifies :run, 'execute[start_resque]', :immediately
    end

    execute 'start_resque' do
      Chef::Log.info("Starting Resque....")
      cwd current_path
      user deploy[:user]
      command 'nohup bundle exec rake resque:work &'
      environment 'RAILS_ENV' => rails_env
      ignore_failure false
      action :nothing
    end

  end


  Chef::Log.info("Precompiling Rails assets with environment #{rails_env}")

  execute 'rake assets:precompile' do
    cwd current_path
    user deploy[:user]
    command 'bundle exec rake assets:precompile'
    environment 'RAILS_ENV' => rails_env
  end

  execute "restart Server" do
    cwd deploy[:current_path]
    command "sleep #{deploy[:sleep_before_restart]} && #{node[:opsworks][:rails_stack][:restart_command]}"
    action :run

    only_if do
      File.exists?(deploy[:current_path])
    end
  end

end