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
