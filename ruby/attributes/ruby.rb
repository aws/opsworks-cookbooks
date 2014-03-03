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

_platform = node[:platform]
_platform_version = node[:platform_version]
arch = RUBY_PLATFORM.match(/64/) ? 'amd64' : 'i386'
rhel_arch = RUBY_PLATFORM.match(/64/) ? 'x86_64' : 'i686'

# Hack to get RedHat 6 to online state until we have proper userspace
# Ruby packages or removed Ruby dependency from custom layer.
if ["redhat", "centos"].include?(_platform)
  _platform = "amazon"
  _platform_version = "2013.09"
end

# ruby_version 1.8.7 is handled by 'ruby-enterprise'
case node["opsworks"]["ruby_version"]
when "2.1"
  default[:ruby][:major_version] = '2'
  default[:ruby][:minor_version] = '1'
  default[:ruby][:patch_version] = '1'
  default[:ruby][:pkgrelease]    = '1'

  i = node[:ruby]
  default[:ruby][:version] = "#{i[:major_version]}.#{i[:minor_version]}.#{i[:patch_version]}"
  default[:ruby][:deb] = "opsworks-ruby#{i[:major_version]}.#{i[:minor_version]}_#{i[:major_version]}.#{i[:minor_version]}.#{i[:patch_version]}.#{i[:pkgrelease]}_#{arch}.deb"
  default[:ruby][:rpm] = "opsworks-ruby#{i[:major_version]}#{i[:minor_version]}-#{i[:major_version]}.#{i[:minor_version]}.#{i[:patch_version]}-#{i[:pkgrelease]}.#{rhel_arch}.rpm"
when "2.0.0"
  default[:ruby][:major_version] = '2.0'
  default[:ruby][:full_version] = '2.0.0'
  default[:ruby][:patch] = 'p451'
  default[:ruby][:pkgrelease] = '1'
when "1.9.3"
  default[:ruby][:major_version] = '1.9'
  default[:ruby][:full_version] = '1.9.3'
  default[:ruby][:patch] = 'p545'
  default[:ruby][:pkgrelease] = '1'
else
  default[:ruby][:major_version] = ''
  default[:ruby][:full_version] = ''
  default[:ruby][:patch] = ''
  default[:ruby][:pkgrelease] = ''
end

default[:ruby][:version] = "#{node[:ruby][:full_version]}#{node[:ruby][:patch]}" unless node[:ruby][:version]

default[:ruby][:deb] = "opsworks-ruby#{node[:ruby][:major_version]}_#{node[:ruby][:full_version]}-#{node[:ruby][:patch]}.#{node[:ruby][:pkgrelease]}_#{arch}.deb" unless node[:ruby][:deb]
default[:ruby][:deb_url] = "#{node[:opsworks_commons][:assets_url]}/packages/#{_platform}/#{_platform_version}/#{node[:ruby][:deb]}"

default[:ruby][:rpm] = "opsworks-ruby#{node[:ruby][:major_version].delete('.')}-#{node[:ruby][:full_version]}-#{node[:ruby][:patch]}-#{node[:ruby][:pkgrelease]}.#{rhel_arch}.rpm" unless node[:ruby][:rpm]
default[:ruby][:rpm_url] = "#{node[:opsworks_commons][:assets_url]}/packages/#{_platform}/#{_platform_version}/#{node[:ruby][:rpm]}"

include_attribute "ruby::customize"
