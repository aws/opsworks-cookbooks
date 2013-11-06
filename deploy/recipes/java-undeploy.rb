include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'java'
    Chef::Log.debug("Skipping deploy::java-undeploy application #{application} as it is not a Java app")
    next
  end

  # ROOT has a special meaning and has to be capitalized
  if application == 'root'
    webapp_name = 'ROOT'
  else
    webapp_name = application
  end

  webapp_dir = ::File.join(node['opsworks_java'][node['opsworks_java']['java_app_server']]['webapps_base_dir'], webapp_name)

  link webapp_dir do
    action :delete
  end

  directory "#{deploy[:deploy_to]}" do
    recursive true
    action :delete
    only_if { ::File.exists?("#{deploy[:deploy_to]}") }
  end

  include_recipe "opsworks_java::#{node['opsworks_java']['java_app_server']}_service"

  execute "trigger #{node['opsworks_java']['java_app_server']} service restart" do
    command '/bin/true'
    not_if { node['opsworks_java'][node['opsworks_java']['java_app_server']]['auto_deploy'].to_s == 'true' }
    notifies :restart, "service[#{node['opsworks_java']['java_app_server']}]"
  end

  include_recipe 'apache2::service'

  link "#{node[:apache][:dir]}/sites-enabled/#{application}.conf" do
    action :delete
    only_if { ::File.exists?("#{node[:apache][:dir]}/sites-enabled/#{application}.conf") }
    notifies :restart, "service[apache2]"
  end
end
