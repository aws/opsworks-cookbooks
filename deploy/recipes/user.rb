Chef::Log.warn("You are including a recipe that is no longer used and depricated: deploy::user")
Chef::Log.warn("Please use the definition `scalarium_deploy_user` instead. See http://support.scalarium.com/kb/deployment/how-to-do-a-custom-deployment")

node[:deploy].each do |application, deploy|

  scalarium_deploy_user do
    deploy_data deploy
  end

end