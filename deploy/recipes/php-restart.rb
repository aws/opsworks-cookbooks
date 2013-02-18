#
# Cookbook Name:: deploy
# Recipe:: php-restart
#

include_recipe "deploy"
include_recipe "apache2::service"

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'php'
    Chef::Log.debug("Skipping deploy::php-restart application #{application} as it is not a PHP app")
    next
  end
  
  execute "restart Apache" do
    cwd deploy[:current_path]
    command "sleep #{deploy[:sleep_before_restart]} && #{deploy[:restart_command]}"
    action :run
    
    only_if do 
      File.exists?(deploy[:current_path])
    end
    
    notifies :restart, resources(:service => "apache2")
  end
    
end


