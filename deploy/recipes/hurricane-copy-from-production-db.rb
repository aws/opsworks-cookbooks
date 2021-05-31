include_recipe 'deploy'
Chef::Log.level = :debug

node[:deploy].first(1).each do |application, deploy|

  production_database = node[:hurricane_api_settings][:production_database]

  if deploy[:rails_env] == 'staging' || deploy[:rails_env] == 'preprod'


    dump_dir = "#{deploy[:deploy_to]}/shared/dump"
    dump_file = [dump_dir, 'snapshot_production'].join('/')
    dump_file_list = [dump_dir, 'snapshot_production.list'].join('/')
    staging_database = deploy[:database]

    directory dump_dir do
      mode '0770'
      owner deploy[:user]
      group deploy[:group]
      action :create
      recursive true
    end

    execute 'dump production database' do
      Chef::Log.debug('Dump Production Database')
      user deploy[:user]
      environment 'PGPASSWORD' => production_database[:password]
      cwd dump_dir
      dump_cmd = 'pg_dump -h %s -d %s --no-owner -x -U %s -F c -f %s'
      command sprintf(dump_cmd, production_database[:host], production_database[:database], production_database[:username], dump_file)
      action :run
    end

    execute 'api readonly to database' do
      Chef::Log.debug('Api readonly to database')
      user deploy[:user]
      environment 'PGPASSWORD' => staging_database[:password]
      disconnect_cmd = "psql -h %s -d %s -U %s -c \"ALTER DATABASE %s SET default_transaction_read_only = true\""
      command sprintf(
                  disconnect_cmd,
                  staging_database[:host],
                  staging_database[:database],
                  staging_database[:username],
                  staging_database[:database]
              )
      action :run
    end
  
    execute 'force close connections to database' do
      Chef::Log.debug('Closing connections')
      user deploy[:user]
      environment 'PGPASSWORD' => staging_database[:password]
      disconnect_cmd = "psql -h %s -d %s -U %s -c \"SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '%s' AND pid <> pg_backend_pid()\""
      command sprintf(
                  disconnect_cmd,
                  staging_database[:host],
                  staging_database[:database],
                  staging_database[:username],
                  staging_database[:database]
              )
      action :run
    end

    execute 'drop current db' do
      Chef::Log.debug('Drop Staging Database')
      user deploy[:user]
      environment 'PGPASSWORD' => staging_database[:password]
      cwd dump_dir
      drop_cmd = 'dropdb -h %s -U %s %s'
      command sprintf(drop_cmd, staging_database[:host], staging_database[:username], staging_database[:database])
      action :run
    end

    execute 'create empty db' do
      Chef::Log.debug('Create Empty Staging Database')
      user deploy[:user]
      environment 'PGPASSWORD' => staging_database[:password]
      cwd dump_dir
      create_cmd = 'createdb -h %s -U %s -T template0 %s'
      command sprintf(create_cmd, staging_database[:host], staging_database[:username], staging_database[:database])
      action :run
    end

    execute 'exclude comments on extension' do
      Chef::Log.debug('Exluding comments on exention')
      user deploy[:user]
      cwd dump_dir
      restore_cmd = "pg_restore -l %s |  grep -v 'COMMENT - EXTENSION' > %s"
      command sprintf(restore_cmd, dump_file, dump_file_list)
      action :run
    end

    execute 'restore into staging database' do
      Chef::Log.debug('Restore Into Staging Database')
      user deploy[:user]
      environment 'PGPASSWORD' => staging_database[:password]
      cwd dump_dir
      restore_cmd = 'pg_restore -h %s -d %s -U %s -O -L %s %s'
      command sprintf(restore_cmd, staging_database[:host], staging_database[:database], staging_database[:username], dump_file_list, dump_file)
      action :run
    end


    # execute 'update user dealer password' do
    #   Chef::Log.debug('Updating user passowrd')
    #   user deploy[:user]
    #   environment 'PGPASSWORD' => staging_database[:password]
    #   update_cmd = "psql -h %s -d %s -U %s -c \"UPDATE users SET encrypted_password = '$2a$10$dnweS3sLpXy2/n2Qhc16yOY9hM7ew46CertcGQW1iW8q02NzBfMs6' WHERE email = 'info@fit2you.it'\""
    #   command sprintf(
    #               update_cmd,
    #               staging_database[:host],
    #               staging_database[:database],
    #               staging_database[:username]
    #           )
    #   action :run
    # end

    file dump_file do
      Chef::Log.debug('Remove Sql Dump')
      action :delete
    end

    file dump_file_list do
      Chef::Log.debug('Remove Sql Dump List')
      action :delete
    end
    
    execute 'api readonly to database' do
      Chef::Log.debug('Api readonly to database')
      user deploy[:user]
      environment 'PGPASSWORD' => staging_database[:password]
      disconnect_cmd = "psql -h %s -d %s -U %s -c \"ALTER DATABASE %s SET default_transaction_read_only = false\""
      command sprintf(
                  disconnect_cmd,
                  staging_database[:host],
                  staging_database[:database],
                  staging_database[:username],
                  staging_database[:database]
              )
      action :run
    end

    execute 'rake db:migrate' do
      Chef::Log.debug('Execute Rails Db Migrate')
      cwd "#{deploy[:deploy_to]}/current"
      user deploy[:user]
      command 'bundle exec rake db:migrate'
      environment 'RAILS_ENV' => deploy[:rails_env]
    end

    execute 'force close connections to database' do
      Chef::Log.debug('Closing connections')
      user deploy[:user]
      environment 'PGPASSWORD' => staging_database[:password]
      disconnect_cmd = "psql -h %s -d %s -U %s -c \"SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '%s' AND pid <> pg_backend_pid()\""
      command sprintf(
                  disconnect_cmd,
                  staging_database[:host],
                  staging_database[:database],
                  staging_database[:username],
                  staging_database[:database]
              )
      action :run
    end

  else
    Chef::Log.debug('Recipe available only in staging/preprod environment')
  end

end
