define :opsworks_aws_flow_ruby do
  deploy = params[:deploy_data]
  application = params[:app]

  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end

  opsworks_deploy_user do
    deploy_data deploy
  end

  # snapshot the config for the runner
  Chef::Log.info("The runner config is #{deploy[:aws_flow_ruby_settings]}")

  file "#{deploy[:deploy_to]}/current/runner_config.json" do
    user deploy[:user]
    group deploy[:group] 
    content "#{deploy[:aws_flow_ruby_settings].to_json}"
  end

  service 'monit' do
    action :nothing
  end

  # the init script that controls the runner
  template "#{deploy[:deploy_to]}/current/runner.initrc" do
    source 'aws_flow_ruby_app.initrc.erb'
    cookbook 'opsworks_aws_flow_ruby'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      :deploy => deploy,
      :application_name => application
    )    
  end

  # the monit part, which will supervise the init script that controls the runner
  template "#{node.default[:monit][:conf_dir]}/aws_flow_ruby-#{application}.monitrc" do
    source 'aws_flow_ruby_app.monitrc.erb'
    cookbook 'opsworks_aws_flow_ruby'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      :deploy => deploy,
      :application_name => application
    )
    notifies :restart, "service[monit]", :immediately
  end
end
