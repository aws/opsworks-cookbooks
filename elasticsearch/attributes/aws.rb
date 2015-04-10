include_attribute 'elasticsearch::default'
include_attribute 'elasticsearch::plugins'

# Load configuration and credentials from data bag 'elasticsearch/aws' -
#
aws = Chef::DataBagItem.load('elasticsearch', 'aws')[node.chef_environment] rescue {}
# ----------------------------------------------------------------------

# To use the AWS discovery, you have to properly set up the configuration,
# either with the data bag, role or environment overrides, or directly
# on the node itself:
#
#    cloud:
#      aws:
#        access_key: <REPLACE>
#        secret_key: <REPLACE>
#        region:     <REPLACE>
#    discovery:
#      type: ec2
#      ec2:
#         groups: <REPLACE>
#
# Instead of using AWS access tokens, you can create the instance with a IAM role;
# see: http://docs.aws.amazon.com/IAM/latest/UserGuide/role-usecase-ec2app.html

default.elasticsearch['plugins']['elasticsearch/elasticsearch-cloud-aws']['version'] = '1.14.0'

# === AWS ===
# AWS configuration is set based on data bag values.
# You may choose to configure them in your node configuration instead.
#
default.elasticsearch[:gateway][:type]               = ( aws['gateway']['type']                rescue nil )
default.elasticsearch[:discovery][:type]             = ( aws['discovery']['type']              rescue nil )
default.elasticsearch[:discovery][:ec2][:groups]     = ( aws['discovery']['ec2']['groups']     rescue nil )
default.elasticsearch[:discovery][:ec2][:tag]        = ( aws['discovery']['ec2']['tag']        rescue {} )

default.elasticsearch[:cloud][:aws][:access_key]     = ( aws['cloud']['aws']['access_key']     rescue nil )
default.elasticsearch[:cloud][:aws][:secret_key]     = ( aws['cloud']['aws']['secret_key']     rescue nil )
default.elasticsearch[:cloud][:aws][:region]         = ( aws['cloud']['aws']['region']         rescue nil )
default.elasticsearch[:cloud][:aws][:ec2][:endpoint] = ( aws['cloud']['aws']['ec2']['endpoint'] rescue nil )

default.elasticsearch[:cloud][:node][:auto_attributes] = true
