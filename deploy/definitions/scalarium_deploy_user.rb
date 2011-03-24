define :scalarium_deploy_user do
  deploy = params[:deploy_data]

  group deploy[:group]

  user deploy[:user] do
    action :create
    comment "deploy user"
    uid next_free_uid
    gid deploy[:group]
    home deploy[:home]
    supports :manage_home => true
    shell deploy[:shell]
  end
end

