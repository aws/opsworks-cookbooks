include_recipe 'deploy'
require 'json'

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'aws-flow-ruby'
    Chef::Log.info("Skipping deploy::aws-flow-ruby application #{application} as it is not an AWS Flow Ruby app")
    next
  end

  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end

  opsworks_aws_flow_ruby do
    deploy_data deploy
    app application
  end

end
