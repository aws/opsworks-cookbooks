include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'java'
    Chef::Log.debug("Skipping deploy::java-rollback application #{application} as it is not a Java app")
    next
  end

  opsworks_deploy do
    deploy_data deploy
    app application
    only_if { File.exists?(deploy[:current_path]) }
  end

  include_recipe "opsworks_java::#{node['opsworks_java']['java_app_server']}_service"

  execute "trigger #{node['opsworks_java']['java_app_server']} service restart" do
    command '/bin/true'
    not_if { node['opsworks_java'][node['opsworks_java']['java_app_server']]['auto_deploy'].to_s == 'true' }
    notifies :restart, "service[#{node['opsworks_java']['java_app_server']}]"
  end
end
