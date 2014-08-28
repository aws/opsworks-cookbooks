action :install do
  if new_resource.database_adapter
    case new_resource.database_adapter
    when /mysql/
      run_context.include_recipe "mysql::client"
    when "postgresql"
      run_context.include_recipe "opsworks_postgresql::client_install"
    end
  end
end
