Chef::Log.warn("You are including a recipe that is no longer used and depricated: deploy::source")
Chef::Log.warn("Please use the definition `scalarium_deploy` instead. See http://support.scalarium.com/kb/deployment/how-to-do-a-custom-deployment")

node[:deploy].each do |application, deploy|
  scalarium_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  scalarium_deploy do
    app application
    deploy_data deploy
  end
end