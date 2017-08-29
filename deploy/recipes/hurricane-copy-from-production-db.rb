include_recipe 'deploy'
Chef::Log.level = :debug

dump_dir = "#{deploy[:deploy_to]}/shared/dump"
dump_file = [dump_dir, 'snapshot_production.sql'].join('/')
postgres = {
    host: 'hurricane-api-db-production.fit2you.info',
    database: 'hurricane_api_production',
    user: 'hurricane-api',
    password: 'dunacato56'
}

node[:deploy].each do |application, deploy|

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


    execute "dump production database" do
      Chef::Log.debug('Dump Production Database')
      Chef::Log.debug("Current Stack Database: #{deploy[:database].inspect}")
      user deploy[:user]
      environment "PGPASSWORD" => postgres[:password]
      cwd dump_dir
      dump_cmd = "pg_dump -h %s --data-only --no-owner --exclude-table-data=schema_migrations -x -U %s %s > %s"
      command sprintf(dump_cmd, postgres[:host], postgres[:username], postgres[:database], dump_file)
      action :run
    end
  else
    Chef::Log.debug('Recipe available only in staging environment')
  end

end
