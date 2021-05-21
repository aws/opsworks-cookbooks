include_recipe 'deploy'
Chef::Log.level = :debug


node[:deploy].each do |application, deploy|

  rails_env = deploy[:rails_env]
  current_path = deploy[:current_path]

  active_job_with_resque = (node[:hurricane_api_settings][:active_job].present? && node[:hurricane_api_settings][:active_job][:adapter] == 'resque')

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

  directory "#{deploy[:deploy_to]}/shared/config/hubspot" do
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

  template "#{deploy[:deploy_to]}/shared/config/s3.yml" do
    source 'hurricane-api/s3.yml.erb'
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

  template "#{deploy[:deploy_to]}/shared/config/previnet_client.yml" do
    source 'hurricane-api/previnet_client.yml.erb'
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

  template "#{deploy[:deploy_to]}/shared/config/hubspot/config.yml" do
    source 'hurricane-api/hubspot/config.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
      :hurricane_api_settings => node[:hurricane_api_settings],
      :env => rails_env
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config/hubspot")
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

  # creo nuovo template per sovrascrivere il file di config di Aviva
  template "#{deploy[:deploy_to]}/shared/config/aviva.yml" do
    source 'hurricane-api/aviva.yml.erb'
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

  template "#{deploy[:deploy_to]}/shared/config/routes/resque_server.rb" do
    source 'hurricane-api/resque_server.rb.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(:hurricane_api_settings => node[:hurricane_api_settings])
    only_if do
      active_job_with_resque && File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/resque.yml" do
    source 'hurricane-api/resque.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :hurricane_api_settings => node[:hurricane_api_settings],
        :env => rails_env
    )
    only_if do
      active_job_with_resque && File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  if active_job_with_resque

    service 'monit' do
      action :restart
    end

    queue_name = ['hurricane_api', rails_env, 'queue'].join('_')
    pid_file_name = ['resque_worker', queue_name, '.pid'].join
    log_file_name = ['resque_worker', queue_name, '.log'].join
    monit_resque_rc = File.join(node[:monit][:conf_dir], 'resque.monitrc')


    template monit_resque_rc do
      source 'hurricane-api/resque.monitrc.erb'
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
      ignore_failure true
      command "monit restart #{queue_name}"
      action :run
    end


  end

  execute "restart Server" do
    Chef::Log.debug('Restarting Rails Server From Hurricane Script')
    cwd deploy[:current_path]
    command "sleep #{deploy[:sleep_before_restart]} && #{node[:opsworks][:rails_stack][:restart_command]}"
    ignore_failure true
    action :run

    only_if do
      File.exists?(deploy[:current_path])
    end
  end

end
