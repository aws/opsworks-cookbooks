include_recipe 'deploy'
Chef::Log.level = :debug

node[:deploy].each do |application, deploy|

  template "#{deploy[:deploy_to]}/shared/config/secrets.yml" do
    source 'lumen/secrets.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :lumen_settings => node[:lumen_settings]
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/mailer.yml" do
    source 'lumen/mailer.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :lumen_settings => node[:lumen_settings]
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/aws.yml" do
    source 'lumen/aws.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :lumen_settings => node[:lumen_settings]
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end   

  execute "create initializiers directory in shared/config" do
    command "mkdir -p #{deploy[:deploy_to]}/shared/config/initializers/"
  end

  template "#{deploy[:deploy_to]}/shared/config/initializers/rollbar.rb" do
    source 'lumen/rollbar.rb.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :lumen_settings => node[:lumen_settings]
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config/initializers")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/initializers/docusign_rest.rb" do
    source 'lumen/docusign_rest.rb.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :lumen_settings => node[:lumen_settings]
    )
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
        :lumen_env => deploy[:env]
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/app/views/shared")
    end
  end

  rails_env = deploy[:rails_env]
  current_path = deploy[:current_path]

  Chef::Log.info("Precompiling Rails assets with environment #{rails_env}")

  execute 'stop queue' do
    cwd current_path
    user 'deploy'
    command 'pkill -f qc:work'
    ignore_failure true
    environment 'RAILS_ENV' => rails_env
  end

  execute 'rake assets:precompile' do
    cwd current_path
    user 'deploy'
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

  execute 'start queue' do
    cwd current_path
    user 'deploy'
    command 'nohup bundle exec rake qc:work &'
    environment 'RAILS_ENV' => rails_env
  end  

end