node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'nodejs'
    Chef::Log.debug("Skipping deploy::nodejs for application #{application} as it is not a node.js app")
    next
  end

  scalarium_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  scalarium_deploy do
    deploy_data deploy
    app application
  end

  scalarium_nodejs do
    deploy_data deploy
    app application
  end

  execute "restart node.js application #{application} via monit" do
    command node[:deploy][application][:nodejs][:restart_command]
  end
end
