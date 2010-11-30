define :scalarium_deploy_user do
  application = params[:app]
  deploy = params[:deploy_data]

  group deploy[:group]

  user deploy[:user] do
    action :create
    comment "deploy user"
    gid deploy[:group]
    home deploy[:home]
    supports :manage_home => true
    shell "/bin/zsh"
  end
end
