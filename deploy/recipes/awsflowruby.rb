include_recipe 'deploy'
require 'json'

Chef::Log.info("I am a message from the #{recipe_name} recipe in the #{cookbook_name} cookbook.")

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'awsflowruby'
    Chef::Log.info("Skipping deploy::awsflowruby application #{application} as it is not an AWS Flow app")
    next
  end

  Chef::Log.info("Doing deploy::awsflowruby application #{application}")

  # create the initrc and monit files
  opsworks_awsflowruby do
    deploy_data deploy
    app application
  end

end
