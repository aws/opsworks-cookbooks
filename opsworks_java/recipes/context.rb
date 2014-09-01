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

  driver_class = case deploy[:database][:type]
  when "mysql"
    'com.mysql.jdbc.Driver'
  when "postgresql"
    'org.postgresql.Driver'
  else
    ''
  end

  template "context file for #{webapp_name}" do
    path ::File.join(node['opsworks_java'][node['opsworks_java']['java_app_server']]['context_dir'], "#{webapp_name}.xml")
    source 'webapp_context.xml.erb'
    owner node['opsworks_java'][node['opsworks_java']['java_app_server']]['user']
    group node['opsworks_java'][node['opsworks_java']['java_app_server']]['group']
    mode 0640
    backup false
    variables(
      :resource_name => node['opsworks_java']['datasources'][application],
      :application => application,
      :driver_class => driver_class,
      :environment => OpsWorks::Escape.escape_xml(deploy[:environment_variables])
    )
    notifies :restart, "service[#{node['opsworks_java']['java_app_server']}]"
  end
end
