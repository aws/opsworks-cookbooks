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
      Chef::Log.debug("Current Stack Database: #{deploy[:database].inspect}")
      user deploy[:user]
      environment 'PGPASSWORD' => production_database[:password]
      cwd dump_dir
      dump_cmd = 'pg_dump -h %s --data-only --no-owner --exclude-table-data=schema_migrations -x -U %s %s > %s'
      command sprintf(dump_cmd, production_database[:password], production_database[:host], production_database[:username], production_database[:database], dump_file)
      action :run
    end

    # execute 'copy into staging database' do
    #   Chef::Log.debug('Copy Into Staging Database')
    #   Chef::Log.debug("Current Stack Database: #{deploy[:database].inspect}")
    #   user deploy[:user]
    #   environment 'PGPASSWORD' => staging_database[:password]
    #   cwd dump_dir
    #   dump_cmd = 'psql -h %s -d %s -U %s < %s'
    #   command sprintf(dump_cmd, staging_database[:host], staging_database[:username], staging_database[:database], dump_file)
    #   action :run
    # end
  else
    Chef::Log.debug('Recipe available only in staging environment')
  end

end
