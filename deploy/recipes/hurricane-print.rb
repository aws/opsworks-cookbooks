include_recipe 'deploy'
Chef::Log.level = :debug

node[:deploy].each do |application, deploy|

  rails_env = deploy[:rails_env]
  current_path = deploy[:current_path]

  active_job_with_resque = (node[:hurricane_print_settings][:active_job].present? && node[:hurricane_print_settings][:active_job][:adapter] == 'resque')

  yum_package 'nodejs'


  template "/etc/cron.hourly/hurricane-print-tmpwatch" do
    source 'hurricane-print/tmpwatch.erb'
    variables(
        :tmp_dir => File.join(deploy[:deploy_to], 'shared','tmp')
    )
    mode '0755'
    owner 'root'
    group 'root'
  end

  directory "#{deploy[:deploy_to]}/shared/config" do
    mode '0770'
    owner deploy[:user]
    group deploy[:group]
    action :create
    recursive true
  end

  directory "#{deploy[:deploy_to]}/shared/tmp" do
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

  template "#{deploy[:deploy_to]}/shared/config/s3.yml" do
    source 'hurricane-print/config/s3.yml.erb'
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

  template "#{deploy[:deploy_to]}/shared/config/guarantee_email_sender.yml" do
    source 'hurricane-print/config/guarantee_email_sender.yml.erb'
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




  template "#{deploy[:deploy_to]}/shared/config/environments/#{rails_env}.rb" do
    source 'hurricane-print/config/environments/environment_config.rb.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :hurricane_print_settings => node[:hurricane_print_settings],
        :pdf_tmp_folder => "#{deploy[:deploy_to]}/shared/tmp"
    )
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

  if active_job_with_resque

    service 'monit' do
      action :nothing
    end

    queue_name = ['hurricane_print', rails_env, 'queue'].join('_')
    pid_file_name = ['resque_worker', queue_name, '.pid'].join
    log_file_name = ['resque_worker', queue_name, '.log'].join

    template File.join(node[:monit][:conf_dir], 'resque.monitrc') do
      source 'hurricane-print/resque.monitrc.erb'
      owner 'root'
      group 'root'
      mode 0644
      variables(
          :pidfile => File.join(deploy[:deploy_to], 'shared', 'pids', pid_file_name),
          :working_dir => deploy[:current_path],
          :log_file => File.join(deploy[:deploy_to], 'shared', 'log', log_file_name),
          :queue_name => queue_name,
          :env => rails_env,
          :home => deploy[:home],
          :user => deploy[:user]
      )

      notifies :restart, "service[monit]"
    end

    execute "restart monit process #{queue_name}" do
      command "monit restart #{queue_name}"
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