include_recipe 'deploy'
require 'json'

Chef::Log.info("I am a message from the #{recipe_name} recipe in the #{cookbook_name} cookbook.")

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'aws-flow-ruby'
    Chef::Log.info("Skipping deploy::aws-flow-ruby application #{application} as it is not an AWS Flow Ruby app")
    next
  end

  Chef::Log.info("Doing deploy::aws-flow-ruby application #{application}")

  # create the initrc and monit files
  opsworks_aws_flow_ruby do
    deploy_data deploy
    app application
  end

end
