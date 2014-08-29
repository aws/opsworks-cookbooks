define :opsworks_aws_flow_ruby do
  deploy = params[:deploy_data]
  application = params[:app]
  deploy_dir = "#{deploy[:deploy_to]}/current"

  # snapshot the config for the runner
  Chef::Log.info("The runner config is #{deploy[:aws_flow_ruby_settings]}")

  # the init script that controls the runner
  template "#{deploy_dir}/runner.initrc" do
    source 'aws_flow_ruby_app.initrc.erb'
    cookbook 'opsworks_aws_flow_ruby'
    owner 'root'
    group 'root'
    mode '0755'
    variables(
      :deploy => deploy,
      :application_name => application,
      :environment => OpsWorks::Escape.escape_double_quotes(deploy[:environment_variables])
    )
    # Notify a restart in case only the env vars changed here
    notifies :run, "ruby_block[restart AWS Flow Ruby application #{application}]"
  end

  file "#{deploy_dir}/runner_config.json" do
    user deploy[:user]
    group deploy[:group]
    content JSON.pretty_generate((deploy[:aws_flow_ruby_settings] || {}).dup.update('user_agent_prefix' => node['opsworks_aws_flow_ruby']['user_agent_prefix']))
    notifies :run, "ruby_block[restart AWS Flow Ruby application #{application}]"
  end

  # Above triggers a restart if the configuration changes. We also want to
  # make sure we trigger a restart if we're doing a setup / deploy (currently
  # anything but configure)
  unless params[:action] == :configure
    ruby_block "force restart" do
      block {}
      notifies :run, "ruby_block[restart AWS Flow Ruby application #{application}]"
    end
  end

  ruby_block "restart AWS Flow Ruby application #{application}" do
    action :nothing
    block do
      # Check for Gemfile
      unless File.exists?("#{deploy_dir}/Gemfile.lock")
        raise "No Gemfile found. You need a Gemfile to use AWS Flow (Ruby)"
      end

      bundle_output = OpsWorks::ShellOut.shellout("/usr/local/bin/bundle list", :cwd => deploy_dir)
      Chef::Log.info bundle_output

      version_match = bundle_output.match(/ aws-flow \((.*)\)$/)
      unless version_match
        raise "Gem 'aws-flow' needs to be added to your Gemfile"
      end

      minimum_version = node['opsworks_aws_flow_ruby']['minimum_flow_gem_version']
      if Gem::Version.new(version_match[1]) < Gem::Version.new(minimum_version)
        raise "Gem 'aws-flow' needs to be version #{minimum_version} or higher."
      end

      Chef::Log.info OpsWorks::ShellOut.shellout("#{deploy_dir}/runner.initrc restart")
    end
  end

  service 'monit' do
    action :nothing
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
    notifies :restart, "service[monit]"
  end

end
