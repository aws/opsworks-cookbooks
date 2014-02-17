###
# Do not use this file to override the opsworks_commons cookbook's default
# attributes.  Instead, please use the customize.rb attributes file,
# which will keep your adjustments separate from the AWS OpsWorks
# codebase and make it easier to upgrade.
#
# However, you should not edit customize.rb directly. Instead, create
# "opsworks_commons/attributes/customize.rb" in your cookbook repository and
# put the overrides in YOUR customize.rb file.
#
# Do NOT create an 'opsworks_commons/attributes/default.rb' in your cookbooks. Doing so
# would completely override this file and might cause upgrade issues.
#
# See also: http://docs.aws.amazon.com/opsworks/latest/userguide/customizing.html
###

default[:opsworks_commons][:assets_url] = 'https://opsworks-instance-assets.s3.amazonaws.com'

default[:ruby][:executable] = '/usr/local/bin/ruby'

include_attribute "opsworks_commons::customize"
