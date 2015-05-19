###
# Do not use this file to override the opsworks_nodejs cookbook's default
# attributes.  Instead, please use the customize.rb attributes file,
# which will keep your adjustments separate from the AWS OpsWorks
# codebase and make it easier to upgrade.
#
# However, you should not edit customize.rb directly. Instead, create
# "opsworks_nodejs/attributes/customize.rb" in your cookbook repository and
# put the overrides in YOUR customize.rb file.
#
# Do NOT create an 'opsworks_nodejs/attributes/opsworks_nodejs.rb' in your cookbooks. Doing so
# would completely override this file and might cause upgrade issues.
#
# See also: http://docs.aws.amazon.com/opsworks/latest/userguide/customizing.html
###

include_attribute 'deploy'

default[:opsworks_nodejs][:version] = '0.10.38'
default[:opsworks_nodejs][:pkgrelease] = '1'
default[:opsworks_nodejs][:npm_install_options] = 'install --production'

include_attribute "opsworks_nodejs::customize"
