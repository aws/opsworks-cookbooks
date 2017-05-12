include_recipe 'deploy'
Chef::Log.level = :debug

node[:deploy].each do |application, deploy|

  template "#{deploy[:deploy_to]}/shared/config/settings.yml" do
    source 'remote_counter/settings.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :remote_counter_settings => node[:remote_counter_settings],
        :remote_counter_env => deploy[:env]
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/unicorn.rb" do
    source 'remote_counter/unicorn.rb.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :remote_counter_settings => node[:remote_counter_settings],
        :working_dir => File.join(deploy[:deploy_to], 'current'),
        :stderr_path => File.join(deploy[:deploy_to], 'shared', 'log','unicorn.stderr.log'),
        :stdout_path => File.join(deploy[:deploy_to], 'shared', 'log','unicorn.stdout.log'),
        :pid_path => File.join(deploy[:deploy_to], 'shared', 'pids','unicorn.pid')
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  execute 'stop_unicorn' do
    Chef::Log.info("Stop Unicorn....")
    cwd current_path
    user 'deploy'
    command "cat #{File.join(deploy[:deploy_to], 'shared', 'pids','unicorn.pid')} | xargs kill -QUIT"
    environment 'REMOTE_COUNTER_ENV' => deploy[:env]
    ignore_failure true
    notifies :run, 'execute[start_unicorn]', :immediately
  end


  execute 'start_unicorn' do
    Chef::Log.info("Start Unicorn....")
    cwd current_path
    user 'deploy'
    command "bundle exec unicorn -c #{File.join(deploy[:deploy_to], 'shared', 'config', 'unicorn.rb')} -D"
    environment 'REMOTE_COUNTER_ENV' => deploy[:env]
    ignore_failure false
    action :nothing
  end




end

