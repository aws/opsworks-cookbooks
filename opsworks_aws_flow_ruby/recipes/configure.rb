node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'aws-flow-ruby'
    Chef::Log.info("Skipping deploy::aws-flow-ruby application #{application} as it is not an AWS Flow Ruby app")
    next
  end

  file "#{deploy[:deploy_to]}/current/runner_config.json" do
    user deploy[:user]
    group deploy[:group]
    content JSON.pretty_generate((deploy[:aws_flow_ruby_settings] || {}).dup.update('user_agent_prefix' => node.default['opsworks_aws_flow_ruby']['user_agent_prefix']))
    notifies :run, "ruby_block[restart AWS Flow Ruby application #{application}]"
  end

  ruby_block "restart AWS Flow Ruby application #{application}" do
    action :nothing
    block do
      Chef::Log.info("restart AWS Flow Ruby via: #{node[:deploy][application][:aws_flow_ruby][:restart_command]}")
      Chef::Log.info(`#{node[:deploy][application][:aws_flow_ruby][:restart_command]}`)
      $? == 0
    end
  end

end