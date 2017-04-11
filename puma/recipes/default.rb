include_recipe 'puma'

node[:deploy].each do |application, deploy|

  puma_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  puma_rails do
    deploy_data deploy
    app application
  end

  puma_deploy do
    deploy_data deploy
    app application
  end
end
