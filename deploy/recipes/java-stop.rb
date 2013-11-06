include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'java'
    Chef::Log.debug("Skipping deploy::java-stop application #{application} as it is not a Java app")
    next
  end

  include_recipe "opsworks_java::#{node['opsworks_java']['java_app_server']}_service"
  
  execute "trigger #{node['opsworks_java']['java_app_server']} service stop" do
    command '/bin/true'
    notifies :stop, "service[#{node['opsworks_java']['java_app_server']}]"
  end

  include_recipe 'apache2::service'
  
  service 'apache2' do
    action :stop
  end
end

