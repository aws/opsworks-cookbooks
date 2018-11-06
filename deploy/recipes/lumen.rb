include_recipe 'deploy'
Chef::Log.level = :debug

node[:deploy].each do |application, deploy|

  rails_env = deploy[:rails_env]
  current_path = deploy[:current_path]

  active_job_with_resque = (node[:lumen_settings][:active_job].present? && node[:lumen_settings][:active_job][:adapter] == 'resque')

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

  template "#{deploy[:deploy_to]}/shared/config/pusher.yml" do
    source 'lumen/config/pusher.yml.erb'
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

  template "#{deploy[:deploy_to]}/shared/config/routes/resque_server.rb" do
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
    variables(lumen_env: rails_env, db_url: File.join(deploy[:deploy_to], 'shared', 'db', "#{rails_env}.sqlite3"))
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

  template "#{deploy[:deploy_to]}/shared/config/s3.yml" do
    source 'lumen/config/s3.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
      :lumen_settings => node[:lumen_settings],
      :lumen_env => rails_env
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
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

  template "#{deploy[:deploy_to]}/shared/config/application.rb" do
    source 'lumen/config/application.rb.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(:lumen_settings => node[:lumen_settings])
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
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
    service 'monit' do
      action :restart
    end

    queue_name = ['lumen', rails_env, 'queue'].join('_')
    pid_file_name = ['resque_worker', queue_name, '.pid'].join
    log_file_name = ['resque_worker', queue_name, '.log'].join
    monit_resque_rc = File.join(node[:monit][:conf_dir], 'resque.monitrc')

    template monit_resque_rc do
      source 'lumen/resque.monitrc.erb'
      owner 'root'
      group 'root'
      mode 0644
      variables(
        :pidfile => File.join(deploy[:deploy_to], 'shared', 'pids', pid_file_name),
        :working_dir => deploy[:current_path],
        :log_file => File.join(deploy[:deploy_to], 'shared', 'log', log_file_name),
        :queue_name => queue_name,
        :worker_count => node[:lumen_settings][:active_job][:worker_count] || 1,
        :env => rails_env,
        :home => deploy[:home],
        :user => deploy[:user]
      )
      notifies :restart, "service[monit]"
    end

    execute "restart monit process #{queue_name}" do
      ignore_failure true
      command "monit restart #{queue_name}"
      action :run
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