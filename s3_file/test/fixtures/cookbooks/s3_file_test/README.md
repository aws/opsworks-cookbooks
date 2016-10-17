#Description

This cookbook defines acceptance tests for `s3_file`. It simple attempts to fetch a file from S3.

##Attributes

- `node['s3_file_test']['bucket']` - The bucket where the test file resides
- `node['s3_file_test']['region']` - The AWS region for the bucket
- `node['s3_file_test']['file']` - The name of the test file
- `node['s3_file_test']['access_key']` - The AWS access key which allows us to fetch our test S3 file
- `node['s3_file_test']['secret_key']` - The AWS secret key which allows us to fetch our test S3 file

