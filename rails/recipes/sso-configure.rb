include_recipe "deploy"

node[:deploy].each do |application, deploy|
  execute "restart Rails app #{application}" do
    cwd deploy[:current_path]
    command node[:opsworks][:rails_stack][:restart_command]
    action :nothing
  end

  execute "if [ ! -f /srv/www/monaco/current/config/cas.yml ]; then ln -s /srv/www/monaco/shared/config/cas.yml /srv/www/monaco/current/config/cas.yml; fi" do
    group deploy[:group]
    user deploy[:user]
  end

  template "#{deploy[:deploy_to]}/shared/config/cas.yml" do
    source "cas.yml.erb"
    cookbook 'rails'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(:database => deploy[:database])
    notifies :run, "execute[restart Rails app #{application}]"
  end

  cron "casino_cleanup" do
    action :create
    minute '*/05'
    hour '*'
    weekday '*'
    user "deploy"
    home "/home/deploy"
    command "cd #{deploy[:deploy_to]}/current && RAILS_ENV=#{deploy[:rails_env]} bundle exec rake casino:cleanup:all > /dev/null"
  end

end
