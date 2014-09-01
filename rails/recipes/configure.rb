include_recipe "deploy"

node[:deploy].each do |application, deploy|

  if deploy[:application_type] != 'rails'
    Chef::Log.debug("Skipping rails::configure application #{application} as it is not an Rails app")
    next
  end

  node.default[:deploy][application][:database][:adapter] = OpsWorks::RailsConfiguration.determine_database_adapter(
    application,
    deploy,
    "#{deploy[:deploy_to]}/current",
    :force => node[:force_database_adapter_detection],
    :consult_gemfile => deploy[:auto_bundle_on_deploy]
  )

  deploy = node[:deploy][application] # update the value, as a key was just added.

  rails_configuration "Update opsworks configration for app #{application.inspect} and restart rails application stack" do
    application application
    deploy_to deploy[:deploy_to]
    rails_env deploy[:rails_env]
    user deploy[:user]
    group deploy[:group]
    database_data deploy[:database]
    memcached_data deploy[:memcached] || {}

    restart true
  end

end
