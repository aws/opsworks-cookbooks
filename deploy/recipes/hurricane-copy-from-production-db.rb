include_recipe 'deploy'
Chef::Log.level = :debug

production_database = {
    host: 'hurricane-api-db-production.fit2you.info',
    database: 'hurricane_api_production',
    username: 'hurricane_api',
    password: 'dunacato56'
}

node[:deploy].first(1).each do |application, deploy|

  dump_dir = "#{deploy[:deploy_to]}/shared/dump"
  dump_file = [dump_dir, 'snapshot_production.sql'].join('/')
  staging_database = deploy[:database]

  if deploy[:rails_env] == 'staging'

    directory dump_dir do
      mode '0770'
      owner deploy[:user]
      group deploy[:group]
      action :create
      recursive true
    end

    if File.exist?(dump_file)
      file dump_file do
        action :delete
      end
    end


    execute 'dump production database' do
      Chef::Log.debug('Dump Production Database')
      user deploy[:user]
      environment 'PGPASSWORD' => production_database[:password]
      cwd dump_dir
      dump_cmd = 'pg_dump -h %s --data-only --no-owner --exclude-table-data=schema_migrations -x -U %s %s > %s'
      command sprintf(dump_cmd, production_database[:host], production_database[:username], production_database[:database], dump_file)
      action :run
    end

    execute 'truncate tables' do
      sql = <<-SQL
      do
      $$
      declare
        truncate_tables_query text;
      begin
        select 'truncate ' || string_agg(format('%I.%I', schemaname, tablename), ',') || ' RESTART IDENTITY CASCADE'
          into truncate_tables_query
        from pg_tables
        where schemaname in ('public') and tableowner = '#{staging_database[:username]}' and tablename != 'schema_migrations';
        execute truncate_tables_query;
      end;
      $$
      SQL
      Chef::Log.debug('Truncate Staging Database Tables')
      user deploy[:user]
      environment 'PGPASSWORD' => staging_database[:password]
      cwd dump_dir
      truncate_cmd = 'psql -h %s -d %s -U %s -c "%s"'
      command sprintf(truncate_cmd, staging_database[:host], staging_database[:database], staging_database[:username], sql)
      action :run
    end

    execute 'copy into staging database' do
      Chef::Log.debug('Copy Into Staging Database')
      user deploy[:user]
      environment 'PGPASSWORD' => staging_database[:password]
      cwd dump_dir
      restore_cmd = 'psql -h %s -d %s -U %s < %s'
      command sprintf(restore_cmd, staging_database[:host], staging_database[:database], staging_database[:username], dump_file)
      action :run
    end
  else
    Chef::Log.debug('Recipe available only in staging environment')
  end

end
