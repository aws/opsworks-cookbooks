node[:deploy].each do |application, deploy|

  deploy = node[:deploy][application]

  Chef::Log.info("Catching the application data from #{deploy[:application]}")
  Chef::Log.info("Environment: RAILS_ENV #{deploy[:rails_env]}")

  Chef::Log.info("Group Name: #{node[:opsworks][:stack][:name].gsub("_","").split().join().capitalize.to_s}")


  if deploy[:rails_env] == "staging"

    node.set[:srvlog] = [{:logfile => "/srv/www/#{deploy[:application]}/current/log/staging.log",
                :buffer_duration => 5000,
                :initial_position => "start_of_file",
                :log_group_name => node[:opsworks][:stack][:name].gsub("_","").split().join().capitalize.to_s,
                :log_stream_name => "staging",
                :datetime_format => "%b %d %H:%M:%S" 
               }, ]
  else
    node.set[:srvlog] = [{:logfile => "/srv/www/#{deploy[:application]}/current/log/production.log",
                :buffer_duration => 5000,
                :initial_position => "start_of_file",
                :log_group_name => node[:opsworks][:stack][:name].gsub("_","").split().join().capitalize.to_s,
                :log_stream_name => "production",
                :datetime_format => "%b %d %H:%M:%S"
               }, ]
  end

  node.set[:srvlog] << {:logfile => "/srv/www/#{deploy[:application]}/current/log/unicorn.stderr.log",
                :buffer_duration => 5000,
                :initial_position => "start_of_file",
                :log_group_name => node[:opsworks][:stack][:name].gsub("_","").split().join().capitalize.to_s,
                :log_stream_name => "unicorn-error",
                :datetime_format => "%b %d %H:%M:%S"
               }

  node.set[:srvlog] << {:logfile => "/srv/www/#{deploy[:application]}/current/log/unicorn.stdout.log",
              :buffer_duration => 5000,
              :initial_position => "start_of_file",
              :log_group_name => node[:opsworks][:stack][:name].gsub("_","").split().join().capitalize.to_s,
              :log_stream_name => "unicorn-out",
              :datetime_format => "%b %d %H:%M:%S"
             } 
	
  customlogs = node[:cloudwatch_custom_logs]

  if customlogs.nil? then
    customlogs = {}
  end

  Chef::Log.info("Rasing the config file")
  template "/tmp/cwlogs.cfg" do
  cookbook "awslogs"
  source "cwlogs.cfg.erb"
  owner "root"
  group "root"
  mode 0644
  variables(:srvlog => node[:srvlog], customlogs:customlogs)
end

  Chef::Log.info("Config file successfully created")
end
