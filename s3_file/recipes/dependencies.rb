chef_gem 'rest-client' do
  version node['s3_file']['rest-client']['version']
  action :install
end
