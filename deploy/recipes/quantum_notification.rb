include_recipe 'deploy'
Chef::Log.level = :debug

node[:deploy].each do |application, deploy|

  god_notification_file = File.join(deploy[:current_path],'notification.god')

  execute "god start notification service" do
    user deploy[:user]
    cwd deploy[:current_path]
    command "bundle exec god -c #{god_notification_file}"
    action :run
    #not_if 'bundle exec god status notification', :cwd => deploy[:current_path]
  end

  template "#{deploy[:deploy_to]}/shared/config/shoryuken.yml" do
    source 'quantum_notification/shoryuken.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :quantum_notification_settings => node[:quantum_notification_settings]
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/mail.yml" do
    source 'quantum_notification/mail.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :quantum_notification_settings => node[:quantum_notification_settings]
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/settings.yml" do
    source 'quantum_notification/settings.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :quantum_notification_settings => node[:quantum_notification_settings]
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  execute "restart god notification service" do
    user deploy[:user]
    cwd deploy[:current_path]
    command "bundle exec god restart notification"
    action :run
  end

end
