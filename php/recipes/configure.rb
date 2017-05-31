node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'php'
    Chef::Log.debug("Skipping php::configure application #{application} as it is not an PHP app")
    next
  end

  # write out opsworks.php
  template "#{deploy[:deploy_to]}/shared/config/opsworks.php" do
    cookbook 'php'
    source 'opsworks.php.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
      :database => deploy[:database],
      :memcached => deploy[:memcached],
      :layers => node[:opsworks][:layers],
      :stack_name => node[:opsworks][:stack][:name]
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  
  # write out database.php
  template "#{deploy[:deploy_to]}/shared/config/database.php" do
    cookbook 'php'
    source 'database.php.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :db_host => node[:deploy][:ci_config][:db_host],
        :db_username => node[:deploy][:ci_config][:db_username],
        :db_password => node[:deploy][:ci_config][:db_password],
        :db_name => node[:deploy][:ci_config][:db_name],
        :ro_db_host => node[:deploy][:ci_config][:ro_db_host],
        :ro_db_username => node[:deploy][:ci_config][:ro_db_username],
        :ro_db_password => node[:deploy][:ci_config][:ro_db_password],
        :ro_db_name => node[:deploy][:ci_config][:ro_db_name]
    )
  end

    # write out config.php
  template "#{deploy[:deploy_to]}/shared/config/config.php" do
    cookbook 'php'
    source 'config.php.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
      :encryption_key => node[:deploy][:ci_config][:encryption_key],
      :lb_hostname => node[:deploy][:ci_config][:lb_hostname],
      :lb_protocol => node[:deploy][:ci_config][:lb_protocol],
      :rodb_on => node[:deploy][:ci_config][:rodb_on], 
      :log_threshold => node[:deploy][:ci_config][:log_threshold], 
      :ruby_api_url => node[:deploy][:ci_config][:ruby_api_url]
    )
    
  end

        # write out php.ini
  template "/etc/php.ini" do
    cookbook 'php'
    source 'php.ini.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
      :timezone => node[:deploy][:ci_config][:timezone],
      :memcache_cluster_uri => node[:deploy][:ci_config][:memcache_cluster_uri]
    )
  end

  service "httpd" do
    action :restart
  end

  service "awslogs" do
    action :restart
  end
end
