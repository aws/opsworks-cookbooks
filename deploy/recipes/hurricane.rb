include_recipe 'deploy'
Chef::Log.level = :debug

node[:deploy].each do |application, deploy|

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

  execute "create initializiers directory in shared/config" do
    command "mkdir -p #{deploy[:deploy_to]}/shared/config/initializers/"
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

  execute "create initializiers directory in app/views/shared" do
    command "mkdir -p #{deploy[:deploy_to]}/shared/app/views/shared/"
  end

  current_path = deploy[:current_path]

  # execute "restart Server" do
  #   Chef::Log.debug('Restarting Rails Server From Hurricane Script')
  #   cwd deploy[:current_path]
  #   command "sleep #{deploy[:sleep_before_restart]} && #{node[:opsworks][:rails_stack][:restart_command]}"
  #   action :run
  #
  #   only_if do
  #     File.exists?(deploy[:current_path])
  #   end
  # end

end