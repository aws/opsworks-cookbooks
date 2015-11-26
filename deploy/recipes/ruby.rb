include_recipe 'deploy'
Chef::Log.level = :debug

node[:deploy].each do |application, deploy|

  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end

  execute "installing bundle" do
    command "sudo gem install bundler"
    action :run
  end

  execute "running bundle" do
    user deploy[:user]
    cwd "#{deploy[:deploy_to]}/current"
    command "bundle install --path vendor"
    action :run
  end

  execute "updating crontab" do
    user deploy[:user]
    cwd "#{deploy[:deploy_to]}/current"
    command "bundle exec whenever -w"
    action :run
  end

  template "#{deploy[:deploy_to]}/shared/config/settings.yml" do
    source 'settings.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :etl_settings => node[:etl_settings]
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

end
