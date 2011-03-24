define :scalarium_deploy_user do
  deploy = params[:deploy_data]

  group deploy[:group]

  user deploy[:user] do
    action :create
    comment "deploy user"
    gid deploy[:group]
    home deploy[:home]
    supports :manage_home => true
    shell "/bin/zsh"
    
    not_if do
      # do not modify existing deploy user!
      require 'etc'
      deploy_user_exists = false
      Etc.passwd do |user|
        if user.name == deploy[:user]
          Chef::Log.info("The deploy user #{deploy[:user]} already exists - skipping create")
          deploy_user_exists = true
        end
      end
      deploy_user_exists
    end
  end
end
