Chef::Log.info 'Detected a db-master layer or at least one MySQL RDS DB instance - making sure the MySQL client is installed'
include_recipe 'mysql::client_install'