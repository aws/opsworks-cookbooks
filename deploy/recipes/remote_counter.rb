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
        :log_dir => File.join(deploy[:deploy_to], 'shared', 'log'),
        :pid_dir => File.join(deploy[:deploy_to], 'shared', 'pids')
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end


end
