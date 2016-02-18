include_recipe 'deploy'
Chef::Log.level = :debug

node[:deploy].each do |application, deploy|

  template "#{deploy[:deploy_to]}/shared/config/aws.yml" do
    source 'quantum/aws.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
      :quantum_settings => node[:quantum_settings]
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/hyena.yml" do
    source 'quantum/hyena.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
      :quantum_settings => node[:quantum_settings]
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end  

  template "#{deploy[:deploy_to]}/shared/config/secrets.yml" do
    source 'quantum/secrets.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :quantum_settings => node[:quantum_settings]
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  execute "create initializiers directory in shared/config" do
    command "mkdir -p #{deploy[:deploy_to]}/shared/config/initializers/"
  end

  template "#{deploy[:deploy_to]}/shared/config/initializers/devise.rb" do
    source 'quantum/devise.rb.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :quantum_settings => node[:quantum_settings]
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config/initializers")
    end
  end


  template "#{deploy[:deploy_to]}/shared/config/initializers/aws.rb" do
    source 'quantum/aws.rb.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :quantum_settings => node[:quantum_settings]
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config/initializers")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/initializers/rollbar.rb" do
    source 'quantum/rollbar.rb.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :quantum_settings => node[:quantum_settings]
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config/initializers")
    end
  end

  rails_env = deploy[:rails_env]
  current_path = deploy[:current_path]

  Chef::Log.info("Precompiling Rails assets with environment #{rails_env}")

  execute 'rake assets:precompile' do
    cwd current_path
    user 'deploy'
    command 'bundle exec rake assets:precompile'
    environment 'RAILS_ENV' => rails_env
  end

  execute "updating crontab" do
    user deploy[:user]
    cwd "#{deploy[:deploy_to]}/current"
    command "bundle exec whenever -w"
    action :run
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