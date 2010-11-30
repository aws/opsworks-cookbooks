define :scalarium_rails do
  deploy = params[:deploy_data]
  application = params[:app]

  if deploy[:application_type] != 'rails'
    Chef::Log.debug("Skipping deploy::rails application #{application} as it is not an Rails app")
    next
  end
  
  include_recipe deploy[:stack][:recipe]
  # create shared/ directory structure
  %w(log config system pids).each do |dir_name|
    directory "#{deploy[:deploy_to]}/shared/#{dir_name}" do
      group deploy[:group]
      owner deploy[:user]
      mode "0770"
      action :create
      recursive true  
    end
  end

  # write out database.yml
  template "#{deploy[:deploy_to]}/shared/config/database.yml" do
    cookbook "rails"
    source "database.yml.erb"
    mode "0660"
    owner deploy[:user]
    group deploy[:group]
    variables(:database => deploy[:database], :environment => deploy[:rails_env])
  end
  
  # write out memcached.yml
  template "#{deploy[:deploy_to]}/shared/config/memcached.yml" do
    cookbook "rails"
    source "memcached.yml.erb"
    mode "0660"
    owner deploy[:user]
    group deploy[:group]
    variables(:memcached => deploy[:memcached], :environment => deploy[:rails_env])
  end
  
  execute "symlinking subdir mount if necessary" do
    command "rm -f /var/www/#{deploy[:mounted_at]}; ln -s #{deploy[:deploy_to]}/current/public /var/www/#{deploy[:mounted_at]}"
    action :run
    only_if do
      deploy[:mounted_at]
    end
  end
 
