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
include_attribute 'opsworks_commons::default'

default[:opsworks_nodejs][:version] = '0.10.25'
default[:opsworks_nodejs][:pkgrelease] = '1'

arch = RUBY_PLATFORM.match(/64/) ? 'amd64' : 'i386'
default[:opsworks_nodejs][:deb] = "opsworks-nodejs-#{node[:opsworks_nodejs][:version]}-#{node[:opsworks_nodejs][:pkgrelease]}_#{arch}.deb"
default[:opsworks_nodejs][:deb_url] = "#{node[:opsworks_commons][:assets_url]}/packages/#{node[:platform]}/#{node[:platform_version]}/#{node[:opsworks_nodejs][:deb]}"

rhel_arch = RUBY_PLATFORM.match(/64/) ? 'x86_64' : 'i686'
default[:opsworks_nodejs][:rpm] = "opsworks-nodejs-#{node[:opsworks_nodejs][:version]}-#{node[:opsworks_nodejs][:pkgrelease]}.#{rhel_arch}.rpm"
default[:opsworks_nodejs][:rpm_url] = "#{node[:opsworks_commons][:assets_url]}/packages/#{node[:platform]}/#{node[:platform_version]}/#{node[:opsworks_nodejs][:rpm]}"

include_attribute "opsworks_nodejs::customize"
