#gem_package 'aws-flow' do
#  source node['opsworks_aws_flow_ruby']['gem_source'] if node['opsworks_aws_flow_ruby']['gem_source']
#  version node['opsworks_aws_flow_ruby']['version']
#end

cookbook_file "aws-flow-1.0.10.gem" do
  path "/tmp/aws-flow-1.0.10.gem"
end


execute "Install unreleased aws-flow gem" do
  command "gem install /tmp/aws-flow-1.0.10.gem"
end
