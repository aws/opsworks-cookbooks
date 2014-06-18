gem_package 'aws-flow' do
  source node['opsworks_aws_flow_ruby']['gem_source'] if node['opsworks_aws_flow_ruby']['gem_source']
  version node['opsworks_aws_flow_ruby']['version']
end
