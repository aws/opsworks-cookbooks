define :opsworks_deploy do
  application = params[:app]
  deploy = params[:deploy_data]

  directory "#{deploy[:deploy_to]}" do
    group deploy[:group]
    owner deploy[:user]
    mode "0775"
    action :create
    recursive true
  end

  if deploy[:scm]
    ensure_scm_package_installed(deploy[:scm][:scm_type])

    prepare_git_checkouts(
      :user => deploy[:user],
      :group => deploy[:group],
      :home => deploy[:home],
      :ssh_key => deploy[:scm][:ssh_key]
    ) if deploy[:scm][:scm_type].to_s == 'git'

    prepare_svn_checkouts(
      :user => deploy[:user],
      :group => deploy[:group],
      :home => deploy[:home],
      :deploy => deploy,
      :application => application
    ) if deploy[:scm][:scm_type].to_s == 'svn'

    if deploy[:scm][:scm_type].to_s == 'archive'
      repository = prepare_archive_checkouts(deploy[:scm])
      deploy[:scm] = {
        :scm_type => 'git',
        :repository => repository
      }
    elsif deploy[:scm][:scm_type].to_s == 's3'
      repository = prepare_s3_checkouts(deploy[:scm])
      deploy[:scm] = {
        :scm_type => 'git',
        :repository => repository
      }
    end
  end

  Chef::Log.debug("Checking out source code of application #{application} with type #{deploy[:application_type]}")

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

  # setup deployment & checkout
  if deploy[:scm]
    deploy deploy[:deploy_to] do
      repository deploy[:scm][:repository]
      user deploy[:user]
      revision deploy[:scm][:revision]
      migrate deploy[:migrate]
      migration_command deploy[:migrate_command]
      environment deploy[:environment]
      symlink_before_migrate( deploy[:symlink_before_migrate] )
      action deploy[:action]

      if deploy[:application_type] == 'rails'
        restart_command "sleep #{deploy[:sleep_before_restart]} && #{node[:opsworks][:rails_stack][:restart_command]}"
      end

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

        if deploy[:application_type] == 'rails'
          if deploy[:auto_bundle_on_deploy]
            OpsWorks::RailsConfiguration.bundle(application, node[:deploy][application], release_path)
          end

          node[:deploy][application][:database][:adapter] = OpsWorks::RailsConfiguration.determine_database_adapter(
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
          end.run_action(:create)
        elsif deploy[:application_type] == 'php'
          template "#{node[:deploy][application][:deploy_to]}/shared/config/opsworks.php" do
            cookbook 'php'
            source 'opsworks.php.erb'
            mode '0660'
            owner node[:deploy][application][:user]
            group node[:deploy][application][:group]
            variables(
              :database => node[:deploy][application][:database],
              :memcached => node[:deploy][application][:memcached],
              :layers => node[:opsworks][:layers]
            )
            only_if do
              File.exists?("#{node[:deploy][application][:deploy_to]}/shared/config")
            end
          end
        elsif deploy[:application_type] == 'nodejs'
          if deploy[:auto_npm_install_on_deploy]
            OpsWorks::NodejsConfiguration.npm_install(application, node[:deploy][application], release_path)
          end
        end

        # run user provided callback file
        run_callback_from_file("#{release_path}/deploy/before_migrate.rb")
      end
    end
  end

  ruby_block "change HOME back to /root after source checkout" do
    block do
      ENV['HOME'] = "/root"
    end
  end

  if deploy[:application_type] == 'rails' && node[:opsworks][:instance][:layers].include?('rails-app')
    case node[:opsworks][:rails_stack][:name]

    when 'apache_passenger'
      passenger_web_app do
        application application
        deploy deploy
      end

    when 'nginx_unicorn'
      unicorn_web_app do
        application application
        deploy deploy
      end

    else
      raise "Unsupport Rails stack"
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
