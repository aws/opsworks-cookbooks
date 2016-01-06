#
# Cookbook Name:: rollback
# Recipe:: web
#

node[:deploy].each do |application, deploy|
  deploy deploy[:deploy_to] do
    user deploy[:user]
    action 'rollback'
    restart_command "sleep #{deploy[:sleep_before_restart]} && #{deploy[:restart_command]}"
  
    only_if do
      File.exists?(deploy[:current_path])
    end
  end
end
