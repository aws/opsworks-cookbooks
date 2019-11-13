jdbc_jar = ::File.join(node['opsworks_java']['tomcat']['java_shared_lib_dir'], 'postgresql-9.4.jdbc41.jar')

remote_file jdbc_jar do
  source 'https://jdbc.postgresql.org/download/postgresql-9.4-1201.jdbc41.jar'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end
