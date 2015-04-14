###
# Do not use this file to override the ruby cookbook's default
# attributes.  Instead, please use the customize.rb attributes file,
# which will keep your adjustments separate from the AWS OpsWorks
# codebase and make it easier to upgrade.
#
# However, you should not edit customize.rb directly. Instead, create
# "ruby/attributes/customize.rb" in your cookbook repository and
# put the overrides in YOUR customize.rb file.
#
# Do NOT create an 'ruby/attributes/ruby.rb' in your cookbooks. Doing so
# would completely override this file and might cause upgrade issues.
#
# See also: http://docs.aws.amazon.com/opsworks/latest/userguide/customizing.html
###

include_attribute 'opsworks_initial_setup::default'
include_attribute 'opsworks_commons::default'

case node["opsworks"]["ruby_version"]
when "2.2"
  default[:ruby][:major_version] = '2'
  default[:ruby][:minor_version] = '2'
  default[:ruby][:patch_version] = '2'
  default[:ruby][:pkgrelease]    = '1'

  default[:ruby][:full_version] = [node[:ruby][:major_version], node[:ruby][:minor_version]].join(".")
  default[:ruby][:version] = [node[:ruby][:full_version], node[:ruby][:patch_version]].join(".")

when "2.1"
  default[:ruby][:major_version] = '2'
  default[:ruby][:minor_version] = '1'
  default[:ruby][:patch_version] = '6'
  default[:ruby][:pkgrelease]    = '1'

  default[:ruby][:full_version] = [node[:ruby][:major_version], node[:ruby][:minor_version]].join(".")
  default[:ruby][:version] = [node[:ruby][:full_version], node[:ruby][:patch_version]].join(".")

when "2.0.0"
  default[:ruby][:major_version] = '2'
  default[:ruby][:minor_version] = '0'
  default[:ruby][:patch] = 'p645' # this attribute will disappear in favor of the sematic versioning schema
  default[:ruby][:patch_version] = node[:ruby][:patch]
  default[:ruby][:pkgrelease] = '1'

  default[:ruby][:full_version] = '2.0.0'
  default[:ruby][:version] = [node[:ruby][:full_version], node[:ruby][:patch_version]].join("-")

when "1.9.3"
  default[:ruby][:major_version] = '1'
  default[:ruby][:minor_version] = '9'
  default[:ruby][:patch] = 'p551'  # this attribute will disappear in favor of the sematic versioning schema
  default[:ruby][:patch_version] = node[:ruby][:patch]
  default[:ruby][:pkgrelease] = '1'

  default[:ruby][:full_version] = '1.9.3'
  default[:ruby][:version] = [node[:ruby][:full_version], node[:ruby][:patch_version]].join("-")

else
  default[:ruby][:major_version] = ''
  default[:ruby][:full_version] = ''
  default[:ruby][:patch_version] = ''
  default[:ruby][:patch] = ''  # this attribute will disappear in favor of the sematic versioning schema
  default[:ruby][:pkgrelease] = ''
  default[:ruby][:version] = ''
end

include_attribute "ruby::customize"
