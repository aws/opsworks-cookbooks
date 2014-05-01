define :opsworks_awsflowruby do
  deploy = params[:deploy_data]
  application = params[:app]

  # FIXME: is this redundant?
  opsworks_deploy_user do
    deploy_data deploy
  end

  # FIXME/TODO: run bundle install

  service 'monit' do
    action :nothing
  end

  # the init script that controls the runner
  template "#{deploy[:deploy_to]}/current/runner.initrc" do
    source 'aws_flow_ruby_app.initrc.erb'
    cookbook 'opsworks_awsflowruby'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      :deploy => deploy,
      :application_name => application
    )    
  end

  # the monit part, which will supervise the init script that controls the runner
  # TODO: finish
  template "#{node.default[:monit][:conf_dir]}/aws_flow_ruby-#{application}.monitrc" do
    source 'aws_flow_ruby_app.monitrc.erb'
    cookbook 'opsworks_awsflowruby'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      :deploy => deploy,
      :application_name => application,
      :monitored_script => "#{deploy[:deploy_to]}/current/server.js"
    )
    notifies :restart, "service[monit]", :immediately
  end
end
