include_recipe 'dependencies'

node[:deploy].each do |application, deploy|

  rails_env = deploy[:rails_env]
  current_path = deploy[:current_path]

  opsworks_deploy_user do
    deploy_data deploy
  end

  # hotfix, create preprod symlink on yet created template, so
  link "#{current_path}/config/environments/#{rails_env}.rb" do
    to "#{deploy[:deploy_to]}/shared/config/environments/#{rails_env}.rb"
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
  end

end
