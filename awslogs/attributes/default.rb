default[:cwlogs][:logfile] = '/var/log/aws/opsworks/opsworks-agent.log'


default[:cwlogs][:service_name] = 'awslogs'

default[:srvlog][:group_name] = ''

default[:srvlog] = [{ :logfile => '/var/log/syslog',
                      :buffer_duration => 5000,
                      :initial_position => 'start_of_file',
                      :log_group_name => node[:opsworks][:stack][:name],
                      :log_stream_name => node[:opsworks][:instance][:hostname],
                      :datetime_format => false}, ]

default[:aws_access_key_id] = 'AKIAJ672IUAWZK5O72KQ'
default[:aws_secret_access_key] = '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'
