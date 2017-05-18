include_recipe 'deploy'

Chef::Log.level = :debug

node[:deploy].each do |application, deploy|

  unicorn_config_dir = File.join(deploy[:deploy_to], 'shared', 'config')

 template File.join(unicorn_config_dir, 'settings.yml') do
    source 'remote_counter/settings.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :remote_counter_settings => node[:remote_counter_settings],
        :remote_counter_env => deploy[:env]
    )
    only_if do
      File.exists?(unicorn_config_dir)
    end
  end

  execute "restart Server" do
    Chef::Log.debug('Restarting Sinatra Server From Remote Counter Script')
    cwd deploy[:current_path]
    command "sleep #{deploy[:sleep_before_restart]} && #{node[:opsworks][:ruby_unicorn_nginx_stack][:restart_command]}"
    action :run

    only_if do
      File.exists?(deploy[:current_path])
    end
  end

end

