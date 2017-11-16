include_recipe 'deploy'

node[:deploy].each do |application, deploy|

  if deploy[:application_type] != 'rails'
    Chef::Log.debug("Skipping deploy::rails application #{application} as it is not a Rails app")
    next
  end

  case deploy[:database][:type]
  when "mysql"
    include_recipe "mysql::client_install"
  when "postgresql"
    if node[:opsworks_postgresql][:yum_repo_template]
      repo_file_path = File.join('/etc/yum.repos.d', node[:opsworks_postgresql][:yum_repo_template])
      unless File.exists?(repo_file_path)
        template repo_file_path do
          source node[:opsworks_postgresql][:yum_repo_template]
          mode '0644'
          owner deploy[:user]
          group deploy[:group]
        end
      end
    end
    include_recipe "opsworks_postgresql::client_install"
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
end
