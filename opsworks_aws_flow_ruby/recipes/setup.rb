#gem_package 'aws-flow' do
#  source node['opsworks_aws_flow_ruby']['gem_source'] if node['opsworks_aws_flow_ruby']['gem_source']
#  version node['opsworks_aws_flow_ruby']['version']
#end

cookbook_file "aws-flow-1.3.0.gem" do
  path "/tmp/aws-flow-1.3.0.gem"
end


execute "Install unreleased aws-flow gem" do
  command "/usr/local/bin/gem install /tmp/aws-flow-1.3.0.gem"
end
