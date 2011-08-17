include_recipe 'dependencies'

node[:deploy].each do |application, deploy|

  scalarium_deploy_user do
    deploy_data deploy
  end

end
