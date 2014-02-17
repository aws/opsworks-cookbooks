###
# Do not use this file to override the opsworks_cleanup cookbook's default
# attributes.  Instead, please use the customize.rb attributes file,
# which will keep your adjustments separate from the AWS OpsWorks
# codebase and make it easier to upgrade.
#
# However, you should not edit customize.rb directly. Instead, create
# "opsworks_cleanup/attributes/customize.rb" in your cookbook repository and
# put the overrides in YOUR customize.rb file.
#
# Do NOT create an 'opsworks_cleanup/attributes/default.rb' in your cookbooks. Doing so
# would completely override this file and might cause upgrade issues.
#
# See also: http://docs.aws.amazon.com/opsworks/latest/userguide/customizing.html
###

include_attribute 'opsworks_initial_setup::default'

default[:opsworks_cleanup][:keep_logs] = 10
default[:opsworks_cleanup][:log_dir] = "#{node[:opsworks_agent][:shared_dir]}/chef"

include_attribute "opsworks_cleanup::customize"
