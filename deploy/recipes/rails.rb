include_recipe 'deploy'

node[:deploy].each do |application, deploy|

  if deploy[:application_type] != 'rails'
    Chef::Log.debug("Skipping deploy::rails application #{application} as it is not a Rails app")
    next
  end

  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_rails do
    deploy_data deploy
    app application
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end

  if node['rails']
    node['rails']['db'].each do |type, dbs|
      if type == 'master'
        template "#{deploy[:deploy_to]}/shared/config/database.yml" do
          source 'database.yml.erb'
          mode "0660"
          group deploy[:group]
          owner deploy[:user]
          variables(dbs: dbs)
        end
      else
        template "#{deploy[:deploy_to]}/shared/config/shards.yml" do
          source 'shards.yml.erb'
          mode "0660"
          group deploy[:group]
          owner deploy[:user]
          variables(dbs: dbs)
        end
      end
    end
  end
end
