###
# Do not use this file to override the ruby_enterprise cookbook's default
# attributes.  Instead, please use the customize.rb attributes file,
# which will keep your adjustments separate from the AWS OpsWorks
# codebase and make it easier to upgrade.
#
# However, you should not edit customize.rb directly. Instead, create
# "ruby_enterprise/attributes/customize.rb" in your cookbook repository and
# put the overrides in YOUR customize.rb file.
#
# Do NOT create an 'ruby_enterprise/attributes/ruby_enterprise.rb' in your cookbooks. Doing so
# would completely override this file and might cause upgrade issues.
#
# See also: http://docs.aws.amazon.com/opsworks/latest/userguide/customizing.html
###

include_attribute 'opsworks_commons::default'
include_attribute 'opsworks_rubygems::rubygems'

case node[:platform]
when 'debian','ubuntu'
    default[:ruby_enterprise][:version] = '2012.02'
    default[:ruby_enterprise][:url][:i386] = "#{node[:opsworks_commons][:assets_url]}/packages/#{node[:platform]}/#{node[:platform_version]}/ruby-enterprise_1.8.7-#{ruby_enterprise[:version]}_i386_ubuntu10.04.deb"
    default[:ruby_enterprise][:url][:amd64] = "#{node[:opsworks_commons][:assets_url]}/packages/#{node[:platform]}/#{node[:platform_version]}/ruby-enterprise_1.8.7-#{ruby_enterprise[:version]}_amd64_ubuntu10.04.deb"

when 'centos','redhat','fedora','amazon'
  default[:ruby_enterprise][:pkgrelease] = '1'
  default[:ruby_enterprise][:version] = '1.8.7'
  default[:ruby_enterprise][:phusion_version] = '2012.02'
  default[:ruby_enterprise][:url][:i686] = "#{node[:opsworks_commons][:assets_url]}/packages/#{node[:platform]}/#{node[:platform_version]}/ruby-enterprise-#{node[:ruby_enterprise][:version]}-#{node[:ruby_enterprise][:phusion_version]}-#{node[:ruby_enterprise][:pkgrelease]}.i686.rpm"
  default[:ruby_enterprise][:url][:x86_64] = "#{node[:opsworks_commons][:assets_url]}/packages/#{node[:platform]}/#{node[:platform_version]}/ruby-enterprise-#{node[:ruby_enterprise][:version]}-#{node[:ruby_enterprise][:phusion_version]}-#{node[:ruby_enterprise][:pkgrelease]}.x86_64.rpm"
end

default[:ruby_enterprise][:gc][:heap_min_slots]           = 500000
default[:ruby_enterprise][:gc][:heap_slots_increment]     = 250000
default[:ruby_enterprise][:gc][:heap_slots_growth_factor] = 1
default[:ruby_enterprise][:gc][:malloc_limit]             = 50000000
default[:ruby_enterprise][:gc][:heap_free_min]            = 4096

include_attribute "ruby_enterprise::customize"
