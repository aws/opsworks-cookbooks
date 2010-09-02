node[:deploy].each do |application, deploy|
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