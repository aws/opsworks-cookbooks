define :scalarium_deploy do
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

    prepare_git_checkouts(:user => deploy[:user],
                          :group => deploy[:group],
                          :home => deploy[:home],
                          :ssh_key => deploy[:scm][:ssh_key]) if deploy[:scm][:scm_type].to_s == 'git'

    prepare_svn_checkouts(:user => deploy[:user],
                          :group => deploy[:group],
                          :home => deploy[:home],
                          :deploy => deploy,
                          :application => application) if deploy[:scm][:scm_type].to_s == 'svn'

    if deploy[:scm][:scm_type].to_s == 'archive'
      repository = prepare_archive_checkouts(deploy[:scm])
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
      symlink_before_migrate deploy[:symlink_before_migrate]
      action deploy[:action]
      restart_command "sleep #{deploy[:sleep_before_restart]} && #{deploy[:restart_command]}"
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
        run_symlinks_before_migrate
        if deploy[:application_type] == 'rails' and deploy[:auto_bundle_on_deploy] and File.exists?("#{release_path}/Gemfile")
          Chef::Log.info("Gemfile detected. Running bundle install.")
          before_migrate_code = "`sudo su deploy -c 'cd #{release_path} && bundle install #{deploy[:home]}/.bundler/#{application} --without=test development'`"
          if File.exists?("#{release_path}/deploy/before_migrate.rb")
            before_migrate_code += "\n" + File.read("#{release_path}/deploy/before_migrate.rb")
          end
          FileUtils.mkdir_p "#{release_path}/deploy"
          File.open("#{release_path}/deploy/before_migrate.rb", 'w') do |file|
            file.puts before_migrate_code
          end
        end
        run_callback_from_file("#{release_path}/deploy/before_migrate.rb")
      end
    end
  end

  ruby_block "change HOME back to /root after source checkout" do
    block do
      ENV['HOME'] = "/root"
    end
  end

  if deploy[:application_type] == 'rails' && node[:scalarium][:instance][:roles].include?('rails-app')
    passenger_web_app do
      application application
      deploy deploy
    end
  end

  log_dirs = []
  log_dirs = node[:deploy].values.map{|deploy| "#{deploy[:deploy_to]}/shared/log" }

  template "/etc/logrotate.d/scalarium_apps" do
    backup false
    source "logrotate.erb"
    cookbook 'deploy'
    owner "root"
    group "root"
    mode 0644
    variables( :log_dirs => log_dirs )
    not_if do
      log_dirs.empty?
    end
  end
end
