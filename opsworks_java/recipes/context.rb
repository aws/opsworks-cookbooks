include_recipe "opsworks_java::#{node['opsworks_java']['java_app_server']}_service"

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'java'
    Chef::Log.debug("Skipping deploy::java application #{application} as it is not a Java app")
    next
  end

  # ROOT has a special meaning and has to be capitalized
  if application == 'root'
    webapp_name = 'ROOT'
  else
    webapp_name = application
  end

  template "context file for #{webapp_name}" do
    path ::File.join(node['opsworks_java'][node['opsworks_java']['java_app_server']]['context_dir'], "#{webapp_name}.xml")
    source 'webapp_context.xml.erb'
    owner node['opsworks_java'][node['opsworks_java']['java_app_server']]['user']
    group node['opsworks_java'][node['opsworks_java']['java_app_server']]['group']
    mode 0640
    backup false
    only_if { node['opsworks_java']['datasources'][application] }
    variables(:resource_name => node['opsworks_java']['datasources'][application], :application => application)
    notifies :restart, "service[#{node['opsworks_java']['java_app_server']}]"
  end
end
