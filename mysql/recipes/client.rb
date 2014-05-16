if node[:opsworks][:layers].has_key?('db-master') || (node[:opsworks][:stack][:rds_instances].any?{|rds_instance| rds_instance[:engine] == 'mysql'})
  Chef::Log.info 'Detected a db-master layer or at least one MySQL RDS DB instance - making sure the MySQL client is installed'
  include_recipe 'mysql::client_install'
else
  Chef::Log.info 'No db-master layer or MySQL RDS DB instance found. Skipping MySQL client package installation.'
end
