define :puma_deploy do
  application = params[:app]
  deploy = params[:deploy_data]

  directory "#{deploy[:deploy_to]}" do
    group 'nginx'
    owner deploy[:user]
    mode "0775"
    action :create
    recursive true
  end

  if deploy[:scm]
    ensure_scm_package_installed(deploy[:scm][:scm_type])

    prepare_git_checkouts(
      :user => deploy[:user],
      :group => 'nginx',
      :home => deploy[:home],
      :ssh_key => deploy[:scm][:ssh_key]
    ) if deploy[:scm][:scm_type].to_s == 'git'

    prepare_svn_checkouts(
      :user => deploy[:user],
      :group => 'nginx',
      :home => deploy[:home],
      :deploy => deploy,
      :application => application
    ) if deploy[:scm][:scm_type].to_s == 'svn'

    if deploy[:scm][:scm_type].to_s == 'archive'
      repository = prepare_archive_checkouts(deploy[:scm])
      node.set[:deploy][application][:scm] = {
        :scm_type => 'git',
        :repository => repository
      }
    elsif deploy[:scm][:scm_type].to_s == 's3'
      repository = prepare_s3_checkouts(deploy[:scm])
      node.set[:deploy][application][:scm] = {
        :scm_type => 'git',
        :repository => repository
      }
    end
  end

  deploy = node[:deploy][application]

  directory "#{deploy[:deploy_to]}/shared/cached-copy" do
    recursive true
    action :delete
    only_if do
      deploy[:delete_cached_copy]
    end
  end

  ruby_block "change HOME to #{deploy[:home]} for source checkout" do
    block do
      ENV['HOME'] = "#{deploy[:home]}"
    end
  end

  puma = node.default[:puma]

  template "#{deploy[:deploy_to]}/shared/scripts/puma" do
    mode '0755'
    owner deploy[:user]
    group 'nginx'
    source "puma.service.erb"
    variables(:deploy => deploy, :application => application)
  end

  service "unicorn_#{application}" do
    retries 5
    retry_delay 2
    start_command "#{deploy[:deploy_to]}/shared/scripts/puma start"
    stop_command "#{deploy[:deploy_to]}/shared/scripts/puma stop"
    restart_command "#{deploy[:deploy_to]}/shared/scripts/puma restart"
    status_command "#{deploy[:deploy_to]}/shared/scripts/puma status"
    action :nothing
    notifies :restart, 'service[nginx]', :immediately
  end

  template "#{deploy[:deploy_to]}/shared/config/puma.rb" do
    mode '0644'
    owner deploy[:user]
    group 'nginx'
    source "puma.conf.erb"
    variables(
      :deploy => deploy,
      :application => application,
      :environment => OpsWorks::Escape.escape_double_quotes(deploy[:environment_variables])
    )
  end

  puma_web_app do
    application application
    deploy deploy
  end

  if deploy[:scm] && deploy[:scm][:scm_type] != 'other'
    Chef::Log.debug("Checking out source code of application #{application}")
    deploy deploy[:deploy_to] do
      provider Chef::Provider::Deploy.const_get(deploy[:chef_provider])
      keep_releases deploy[:keep_releases]
      repository deploy[:scm][:repository]
      user deploy[:user]
      group 'nginx'
      revision deploy[:scm][:revision]
      migrate deploy[:migrate]
      migration_command deploy[:migrate_command]
      environment deploy[:environment].to_hash
      purge_before_symlink(deploy[:purge_before_symlink]) unless deploy[:purge_before_symlink].nil?
      create_dirs_before_symlink(deploy[:create_dirs_before_symlink])
      symlink_before_migrate(deploy[:symlink_before_migrate])
      symlinks(deploy[:symlinks]) unless deploy[:symlinks].nil?
      action deploy[:action]

      restart_command "#{puma[:restart_command]} && sleep 2"

      case deploy[:scm][:scm_type].to_s
      when 'git'
        scm_provider :git
        enable_submodules deploy[:enable_submodules]
        shallow_clone deploy[:shallow_clone]
      when 'svn'
        scm_provider :subversion
        svn_username deploy[:scm][:user]
        svn_password deploy[:scm][:password]
        svn_arguments "--no-auth-cache --non-interactive --trust-server-cert"
        svn_info_args "--no-auth-cache --non-interactive --trust-server-cert"
      else
        raise "unsupported SCM type #{deploy[:scm][:scm_type].inspect}"
      end

      before_migrate do
        link_tempfiles_to_current_release

        if deploy[:auto_bundle_on_deploy]
          OpsWorks::RailsConfiguration.bundle(application, node[:deploy][application], release_path)
        end

        node.default[:deploy][application][:database][:adapter] = OpsWorks::RailsConfiguration.determine_database_adapter(
          application,
          node[:deploy][application],
          release_path,
          :force => node[:force_database_adapter_detection],
          :consult_gemfile => node[:deploy][application][:auto_bundle_on_deploy]
        )
        template "#{node[:deploy][application][:deploy_to]}/shared/config/database.yml" do
          cookbook "rails"
          source "database.yml.erb"
          mode "0660"
          owner node[:deploy][application][:user]
          group node[:deploy][application][:group]
          variables(
            :database => node[:deploy][application][:database],
            :environment => node[:deploy][application][:rails_env]
          )

          only_if do
            deploy[:database][:host].present?
          end
        end.run_action(:create)

        run_callback_from_file("#{release_path}/deploy/before_migrate.rb")
      end
    end
  end

  ruby_block "change HOME back to /root after source checkout" do
    block do
      ENV['HOME'] = "/root"
    end
  end

  template "/etc/logrotate.d/opsworks_app_#{application}" do
    backup false
    source "logrotate.erb"
    cookbook 'deploy'
    owner "root"
    group "root"
    mode 0644
    variables( :log_dirs => ["#{deploy[:deploy_to]}/shared/log" ] )
  end
end
