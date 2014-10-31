###
# Do not use this file to override the opsworks_custom_cookbooks cookbook's default
# attributes.  Instead, please use the customize.rb attributes file,
# which will keep your adjustments separate from the AWS OpsWorks
# codebase and make it easier to upgrade.
#
# However, you should not edit customize.rb directly. Instead, create
# "opsworks_custom_cookbooks/attributes/customize.rb" in your cookbook repository and
# put the overrides in YOUR customize.rb file.
#
# Do NOT create an 'opsworks_custom_cookbooks/attributes/default.rb' in your cookbooks. Doing so
# would completely override this file and might cause upgrade issues.
#
# See also: http://docs.aws.amazon.com/opsworks/latest/userguide/customizing.html
###
include_attribute 'opsworks_commons::default'
default['opsworks_berkshelf']['prebuilt_versions'] = ['2.0.14', '2.0.18', '3.0.1', '3.1.1', '3.1.3', '3.1.5', '3.2.0']

default['opsworks_berkshelf']['version'] = node['opsworks_custom_cookbooks']['berkshelf_version'] || node['opsworks_berkshelf']['prebuilt_versions'].last
default['opsworks_berkshelf']['pkg_release'] = '1'

default['opsworks_berkshelf']['rubygems_options'] = ''
default['opsworks_berkshelf']['debug'] = false
