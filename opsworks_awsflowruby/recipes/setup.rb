gem_package 'aws-flow' do
  source node['opsworks_awsflowruby']['gem_source'] if node['opsworks_awsflowruby']['gem_source']
  version node['opsworks_awsflowruby']['version']
end

gem_package 'bundler' do
  #FIXME: do we want/need to anchor the version?
end
