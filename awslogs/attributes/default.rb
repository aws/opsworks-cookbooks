default[:cwlogs][:logfile] = '/var/log/aws/opsworks/opsworks-agent.log'


default[:srvlog] = [{ :logfile => '/var/log/syslog', 
					   :buffer_duration => 5000, 
					   :initial_position => 'start_of_file',
	                   :log_group_name => node[:opsworks][:stack][:name], 
	                   :log_stream_name => node[:opsworks][:instance][:hostname],
	                   :datetime_format => ''}, ]
