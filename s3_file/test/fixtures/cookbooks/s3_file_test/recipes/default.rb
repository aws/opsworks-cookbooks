
s3_file '/root/kitchen-test' do
  remote_path node['s3_file_test']['file']
  bucket node['s3_file_test']['bucket']
  aws_access_key_id node['s3_file_test']['access_key']
  aws_secret_access_key node['s3_file_test']['secret_key']
  mode 0600
  owner 'root'
  group 'root'
end

