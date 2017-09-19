include_recipe 'deploy'
Chef::Log.level = :debug

node[:deploy].each do |application, deploy|

  rails_env = deploy[:rails_env]
  current_path = deploy[:current_path]

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

  directory "#{deploy[:deploy_to]}/shared/config/environments" do
    mode '0770'
    owner deploy[:user]
    group deploy[:group]
    action :create
    recursive true
  end

  template "#{deploy[:deploy_to]}/shared/config/secrets.yml" do
    source 'hurricane/secrets.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :hurricane_settings => node[:hurricane_settings]
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/slimpay.yml" do
    source 'hurricane/slimpay.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :hurricane_settings => node[:hurricane_settings],
        :env => rails_env
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/twilio.yml" do
    source 'hurricane/twilio.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :hurricane_settings => node[:hurricane_settings],
        :env => rails_env
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/infocar.yml" do
    source 'hurricane/infocar.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :hurricane_settings => node[:hurricane_settings],
        :env => rails_env
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/environments/#{rails_env}.rb" do
    source "hurricane/environment_config.rb.erb"
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :hurricane_settings => node[:hurricane_settings]
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config/environments")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/initializers/docusign_rest.rb" do
    source 'hurricane/docusign_rest.rb.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(:hurricane_settings => node[:hurricane_settings])
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config/initializers")
    end
  end


  template "#{deploy[:deploy_to]}/shared/config/initializers/rollbar.rb" do
    source 'hurricane/rollbar.rb.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :hurricane_settings => node[:hurricane_settings]
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config/initializers")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/remote_counter.yml" do
    source 'hurricane/remote_counter.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :hurricane_settings => node[:hurricane_settings],
        :env => rails_env
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
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
