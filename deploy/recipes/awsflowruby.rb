include_recipe 'deploy'
require 'json'

Chef::Log.info("I am a message from the #{recipe_name} recipe in the #{cookbook_name} cookbook.")

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'awsflowruby'
    Chef::Log.info("Skipping deploy::awsflowruby application #{application} as it is not an AWS Flow app")
    next
  end

  Chef::Log.info("Doing deploy::awsflowruby application #{application}")

  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

#  opsworks_deploy do
#    deploy_data deploy
#    app application
#  end

  Chef::Log.info("The runner config is #{deploy[:runner_config]}")

  # snapshot the runner configuration 
  file "#{deploy[:deploy_to]}/current/runner_config.json" do
    user deploy[:user]
    group deploy[:group] 
    content "#{deploy[:runner_config].to_json}"
  end

  # create the initrc and monit files
  opsworks_awsflowruby do
    deploy_data deploy
    app application
  end
  

  # TODO
end
