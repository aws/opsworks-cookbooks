node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'aws-flow-ruby'
    Chef::Log.info("Skipping deploy::aws-flow-ruby application #{application} as it is not an AWS Flow Ruby app")
    next
  end

  file "#{deploy[:deploy_to]}/current/runner_config.json" do
    user deploy[:user]
    group deploy[:group]
    content JSON.pretty_generate((deploy[:aws_flow_ruby_settings] || {}).dup.update('user_agent_prefix' => node['opsworks_aws_flow_ruby']['user_agent_prefix']))
    notifies :run, "ruby_block[restart AWS Flow Ruby application #{application}]"
  end

  ruby_block "restart AWS Flow Ruby application #{application}" do
    action :nothing
    block do
      # Check for Gemfile
      unless File.exists?("#{deploy[:deploy_to]}/current/Gemfile.lock")
        raise "No Gemfile found. You need a Gemfile to use AWS Flow (Ruby)"
      end

      bundle_output = OpsWorks::ShellOut.shellout("/usr/local/bin/bundle list", :cwd => "#{deploy[:deploy_to]}/current")
      Chef::Log.info bundle_output

      version_match = bundle_output.match(/ aws-flow \((.*)\)$/)
      unless version_match
        raise "Gem 'aws-flow' needs to be added to your Gemfile"
      end

      minimum_version = node['opsworks_aws_flow_ruby']['minimum_flow_gem_version']
      if Gem::Version.new(version_match[1]) < Gem::Version.new(minimum_version)
        raise "Gem 'aws-flow' needs to be version #{minimum_version} or higher."
      end

      # If we make it here, trigger restart
      Chef::Log.info OpsWorks::ShellOut.shellout("#{deploy[:deploy_to]}/current/runner.initrc restart")
    end
  end

end
