include_recipe 'deploy'
Chef::Log.level = :debug

node[:deploy].each do |application, deploy|

  rails_env = deploy[:rails_env]
  current_path = deploy[:current_path]

  active_job_with_resque = (node[:hurricane_print_settings][:active_job].present? && node[:hurricane_print_settings][:active_job][:adapter] == 'resque')

  yum_package 'nodejs'

  directory "#{deploy[:deploy_to]}/shared/config" do
    mode '0770'
    owner deploy[:user]
    group deploy[:group]
    action :create
    recursive true
  end

  directory "#{deploy[:deploy_to]}/shared/app" do
    mode '0770'
    owner deploy[:user]
    group deploy[:group]
    action :create
    recursive true
  end

  directory "#{deploy[:deploy_to]}/shared/db" do
    mode '0770'
    owner deploy[:user]
    group deploy[:group]
    action :create
    recursive true
  end

  directory "#{deploy[:deploy_to]}/shared/config/routes" do
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

  template "#{deploy[:deploy_to]}/shared/config/resque.yml" do
    source 'hurricane-print/config/resque.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :hurricane_print_settings => node[:hurricane_print_settings],
        :hurricane_print_env => rails_env
    )
    only_if do
      active_job_with_resque && File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/docraptor.yml" do
    source 'hurricane-print/config/docraptor.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :hurricane_print_settings => node[:hurricane_print_settings],
        :hurricane_print_env => rails_env
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/routes/resque_server.rb" do
    source 'hurricane-print/config/routes/resque_server.rb.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(:hurricane_print_settings => node[:hurricane_print_settings])
    only_if do
      active_job_with_resque && File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/secrets.yml" do
    source 'hurricane-print/config/secrets.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(:hurricane_print_settings => node[:hurricane_print_settings])
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/database.yml" do
    source 'hurricane-print/config/database.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(hurricane_print_env: rails_env, db_url: File.join(deploy[:deploy_to], 'shared', 'db', "#{rails_env}.sqlite3"))
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/mailer.yml" do
    source 'hurricane-print/config/mailer.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(:hurricane_print_settings => node[:hurricane_print_settings])
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/aws.yml" do
    source 'hurricane-print/config/aws.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(:hurricane_print_settings => node[:hurricane_print_settings])
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end




  template "#{deploy[:deploy_to]}/shared/config/environments/#{rails_env}.rb" do
    source 'hurricane-print/config/environments/environment_config.rb.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(:hurricane_print_settings => node[:hurricane_print_settings])
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config/environments")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/initializers/rollbar.rb" do
    source 'hurricane-print/config/initializers/rollbar.rb.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(:hurricane_print_settings => node[:hurricane_print_settings])
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config/initializers")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/initializers/docusign_rest.rb" do
    source 'hurricane-print/config/initializers/docusign_rest.rb.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(:hurricane_print_settings => node[:hurricane_print_settings])
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config/initializers")
    end
  end

template "#{deploy[:deploy_to]}/shared/app/views/shared/_rollbar.js.erb" do
    source 'hurricane-print/_rollbar.js.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :hurricane_print_settings => node[:hurricane_print_settings],
        :hurricane_print_env => rails_env
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