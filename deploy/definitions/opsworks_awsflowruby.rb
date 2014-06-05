define :opsworks_awsflowruby do
  deploy = params[:deploy_data]
  application = params[:app]

  # FIXME: is it correct to call/use all these opsworks definitions from here?


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

  # make sure the app is properly installed by running "bundle install"
  # on the Gemfile if there is one
  # TODO: FIXME


  # snapshot the config for the runner
  Chef::Log.info("The runner config is #{deploy[:runner_config]}")

  file "#{deploy[:deploy_to]}/current/runner_config.json" do
    user deploy[:user]
    group deploy[:group] 
    content "#{deploy[:runner_config].to_json}"
  end


  service 'monit' do
    action :nothing
  end

  # create the init script that controls the runner
  template "#{deploy[:deploy_to]}/current/runner-#{application}.initrc" do
    source 'aws_flow_ruby_app.initrc.erb'
    cookbook 'opsworks_awsflowruby'
    owner 'root'
    group 'root'
    mode '0655'
    variables(
      :deploy => deploy,
      :application_name => application
    )    
  end

  # create the monit script that will use the init script
  template "#{node.default[:monit][:conf_dir]}/aws_flow_ruby-#{application}.monitrc" do
    source 'aws_flow_ruby_app.monitrc.erb'
    cookbook 'opsworks_awsflowruby'
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
