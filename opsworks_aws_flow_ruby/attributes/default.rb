default['opsworks_aws_flow_ruby']['user'] = 'deploy'
default['opsworks_aws_flow_ruby']['group'] = 'deploy'
default['opsworks_aws_flow_ruby']['version'] = node['opsworks']['aws_flow_ruby_gem_version'] || '1.3.0'
default['opsworks_aws_flow_ruby']['user_agent_prefix'] = 'ruby-flow-opsworks'