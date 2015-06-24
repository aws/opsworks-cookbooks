include_recipe "deploy"

node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  execute "restart Rails app #{application}" do
    cwd deploy[:current_path]
    command node[:opsworks][:rails_stack][:restart_command]
    action :nothing
  end

  node.default[:deploy][application][:database][:adapter] = OpsWorks::RailsConfiguration.determine_database_adapter(application, node[:deploy][application], "#{node[:deploy][application][:deploy_to]}/current", :force => node[:force_database_adapter_detection])
  deploy = node[:deploy][application]

  db_vars = Hash.new

  deploy[:environment_variables].each do |k, v|
    if k.match(/^db_/)
      va = v.split(',')
      db_vars[k[3, k.length]] = Hash.new
      va.each do |x|
        xa = x.split(':')
        db_vars[k[3, k.length]][xa[0]] = xa[1]
      end
    end
  end

  puts(db_vars)

  template "#{deploy[:deploy_to]}/shared/config/database.yml" do
    source "database.yml.erb"
    cookbook 'nca'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(:database => deploy[:database], :environment => deploy[:rails_env], :dbs => db_vars, :folder => deploy[:deploy_to])

    notifies :run, "execute[restart Rails app #{application}]"

    only_if do
      ( deploy[:database][:host].present? || db_vars.length >= 1 ) && File.directory?("#{deploy[:deploy_to]}/shared/config/")
    end
  end

end