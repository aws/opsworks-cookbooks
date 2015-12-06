###
# Do not use this file to override the puma cookbook's default
# attributes.  Instead, please use the customize.rb attributes file,
# which will keep your adjustments separate from the AWS OpsWorks
# codebase and make it easier to upgrade.
#
# However, you should not edit customize.rb directly. Instead, create
# "puma/attributes/customize.rb" in your cookbook repository and
# put the overrides in YOUR customize.rb file.
#
# Do NOT create an 'puma/attributes/default.rb' in your cookbooks. Doing so
# would completely override this file and might cause upgrade issues.
#
# See also: http://docs.aws.amazon.com/opsworks/latest/userguide/customizing.html
###

include_attribute 'rails::rails'

# Usually this should be a dynamic value but we are using threads in order to scale properly
default[:puma][:workers] = 4
default[:puma][:preload_app] = true
default[:puma][:version] = '2.11.3'
default[:puma][:threads_min] = node[:rails][:max_pool_size] ? node[:rails][:max_pool_size]/8 : 1
default[:puma][:threads_max] = node[:rails][:max_pool_size] ? node[:rails][:max_pool_size]/4 : 4

include_attribute "puma::customize"


