chef_gem 'rest-client' do
  version node['s3_file']['rest-client']['version']
  action :install
  compile_time true if Chef::Resource::ChefGem.method_defined?(:compile_time)
end
