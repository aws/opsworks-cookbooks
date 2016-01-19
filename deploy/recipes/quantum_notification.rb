include_recipe 'deploy'
Chef::Log.level = :debug

node[:deploy].each do |application, deploy|

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


  execute "restart" do
    user deploy[:user]
    cwd "#{deploy[:deploy_to]}/current"
    command "bundle exec rake restart"
    action :run
  end

end
