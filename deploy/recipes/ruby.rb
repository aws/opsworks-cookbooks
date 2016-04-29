include_recipe 'deploy'
Chef::Log.level = :debug

node[:deploy].each do |application, deploy|
  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end

  execute "installing bundle" do
    command "sudo gem install bundler -v=1.10.6"
    action :run
  end

  execute "running bundle" do
    user deploy[:user]
    cwd "#{deploy[:deploy_to]}/current"
    command "bundle install --path vendor"
    action :run
  end
end
