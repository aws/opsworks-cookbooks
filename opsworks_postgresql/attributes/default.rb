###
# Do not use this file to override the opsworks_opsworks_postgresql cookbook's default
# attributes.  Instead, please use the customize.rb attributes file,
# which will keep your adjustments separate from the AWS OpsWorks
# codebase and make it easier to upgrade.
#
# However, you should not edit customize.rb directly. Instead, create
# "opsworks_opsworks_postgresql/attributes/customize.rb" in your cookbook repository and
# put the overrides in YOUR customize.rb file.
#
# Do NOT create an 'opsworks_opsworks_postgresql/attributes/default.rb' in your cookbooks. Doing so
# would completely override this file and might cause upgrade issues.
#
# See also: http://docs.aws.amazon.com/opsworks/latest/userguide/customizing.html
###
case node[:platform]
when "redhat","centos","fedora","amazon"
  default[:opsworks_postgresql][:devel_package] = "postgresql-devel"
  default[:opsworks_postgresql][:client_package] = "postgresql"
when "debian","ubuntu"
  default[:opsworks_postgresql][:devel_package] = "libpq-dev"
  default[:opsworks_postgresql][:client_package] = "postgresql-client"
end
include_attribute "opsworks_postgresql::customize"
