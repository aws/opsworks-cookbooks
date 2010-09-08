include_recipe "deploy::directory"
include_recipe "deploy::scm"

node[:deploy].each do |application, deploy|
  
  if deploy[:application_type] == 'rails' && !node[:scalarium][:instance][:roles].include?('rails-app')
    Chef::Log.debug("Skipping checking out source code as application #{application} as is a Rails app and this is not a Rails Application Server")
    next 
  end
  
  if deploy[:application_type] == 'php' && !node[:scalarium][:instance][:roles].include?('php-app')
    Chef::Log.debug("Skipping checking out source code as application #{application} as is a PHP app and this is not a PHP Application Server")
    next 
  end
  
  if deploy[:application_type] == 'static' && !node[:scalarium][:instance][:roles].include?('web')
    Chef::Log.debug("Skipping checking out source code as application #{application} as is a static HTML app and this is not a Web Server")
    next 
  end
  
  Chef::Log.debug("Checking out source code of application #{application} with type #{deploy[:application_type]}")
  
  directory "#{deploy[:deploy_to]}/shared/cached-copy" do
    recursive true
    action :delete
  end

  # setup deployment & checkout
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
    else
      raise "unsupported SCM type #{deploy[:scm][:scm_type].inspect}"
    end

    before_migrate do
      if File.exists?("#{release_path}/Gemfile")
        Chef::Log.info("Gemfile detected. Running bundle install.")
        sudo("cd #{release_path} && bundle install --system --without=test")
      end
      run_callback_from_file("#{release_path}/deploy/before_migrate.rb")
    end
  end

  if deploy[:application_type] == 'rails' && node[:scalarium][:instance][:roles].include?('rails-app')
    passenger_web_app do
      application application
      deploy deploy
    end
  end
end

include_recipe "deploy::logrotate"
