include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'java'
    Chef::Log.debug("Skipping deploy::java application #{application} as it is not a Java app")
    next
  end

  case deploy[:database][:type]
  when "mysql"
    connector_jar = node['opsworks_java']['tomcat']['mysql_connector_jar']
    connector_jar_path = ::File.join(node['opsworks_java']['tomcat']['java_shared_lib_dir'], connector_jar)
    include_recipe "opsworks_java::mysql_connector"
  when "postgresql"
    connector_jar = node[:platform].eql?('ubuntu') ? 'postgresql-jdbc4.jar' : 'postgresql-jdbc.jar'
    connector_jar_path = ::File.join(node['opsworks_java']['tomcat']['java_shared_lib_dir'], connector_jar)
    include_recipe "opsworks_java::postgresql_connector"
  else
    connector_jar = ""
    connector_jar_path = ""
  end

  link ::File.join(node['opsworks_java']['tomcat']['lib_dir'], connector_jar) do
    to connector_jar_path
    action :create
    only_if { ::File.file?(connector_jar_path) }
  end

  # ROOT has a special meaning and has to be capitalized
  if application == 'root'
    webapp_name = 'ROOT'
  else
    webapp_name = application
  end

  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end

  current_dir = ::File.join(deploy[:deploy_to], 'current')
  webapp_dir = ::File.join(node['opsworks_java'][node['opsworks_java']['java_app_server']]['webapps_base_dir'], webapp_name)

  # opsworks_deploy creates some stub dirs, which are not needed for typical webapps
  ruby_block "remove unnecessary directory entries in #{current_dir}" do
    block do
      node['opsworks_java'][node['opsworks_java']['java_app_server']]['webapps_dir_entries_to_delete'].each do |dir_entry|
        ::FileUtils.rm_rf(::File.join(current_dir, dir_entry), :secure => true)
      end
    end
  end

  link webapp_dir do
    to current_dir
    action :create
  end

  include_recipe "opsworks_java::#{node['opsworks_java']['java_app_server']}_service"

  execute "trigger #{node['opsworks_java']['java_app_server']} service restart" do
    command '/bin/true'
    not_if { node['opsworks_java'][node['opsworks_java']['java_app_server']]['auto_deploy'].to_s == 'true' }
    notifies :restart, "service[#{node['opsworks_java']['java_app_server']}]"
  end
end

include_recipe 'opsworks_java::web_app'
include_recipe 'opsworks_java::context'
