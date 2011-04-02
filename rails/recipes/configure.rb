
include_recipe "deploy"

node[:deploy].each do |application, deploy|
  
  execute "restart Rails app #{application}" do
    cwd deploy[:current_path]
    command "touch tmp/restart.txt"
    action :nothing
  end
  
  ruby_block 'Determine database adapter' do
    inner_deploy = deploy
    inner_application = application
    block do
      inner_deploy[:database][:adapter] = if File.exists?("#{inner_deploy[:deploy_to]}/current/config/application.rb")
        Chef::Log.info("Looks like #{inner_application} is a Rails 3 application")
        'mysql2'
      else
        Chef::Log.info("No config/application.rb found, assuming #{inner_application} is a Rails 2 application")
        'mysql'
      end
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/database.yml" do
    source "database.yml.erb"
    cookbook 'rails'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(:database => deploy[:database], :environment => deploy[:rails_env])
  
    if deploy[:stack][:needs_reload]
      notifies :run, resources(:execute => "restart Rails app #{application}")
    end
  
    only_if do
      File.exists?("#{deploy[:deploy_to]}") && File.exists?("#{deploy[:deploy_to]}/shared/config/")
    end
  end
  
  template "#{deploy[:deploy_to]}/shared/config/memcached.yml" do
    source "memcached.yml.erb"
    cookbook 'rails'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(:memcached => deploy[:memcached], :environment => deploy[:rails_env])
  
    if deploy[:stack][:needs_reload]
      notifies :run, resources(:execute => "restart Rails app #{application}")
    end
  
    only_if do
      File.exists?("#{deploy[:deploy_to]}") && File.exists?("#{deploy[:deploy_to]}/shared/config/")
    end
  end
end