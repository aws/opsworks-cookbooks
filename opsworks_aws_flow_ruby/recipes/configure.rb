node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'aws-flow-ruby'
    Chef::Log.info("Skipping configuration of aws-flow-ruby application #{application} as it is not an AWS Flow Ruby app")
    next
  end

  unless File.exists?("#{deploy[:deploy_to]}/current")
    Chef::Log.info("Skipping configuration of aws-flow-ruby application #{application} as it has not yet been deployed")
    next
  end

  opsworks_aws_flow_ruby do
    deploy_data deploy
    app application
    action :configure
  end

end
