case node[:platform]
when 'debian','ubuntu'
  if node[:platform_version] == '9.10'
    default[:ruby_enterprise][:version]                       = '2010.01'
    default[:ruby_enterprise][:url][:i386]                    = "http://peritor-assets.s3.amazonaws.com/ruby-enterprise_1.8.7-#{ruby_enterprise[:version]}_i386.deb"
    default[:ruby_enterprise][:url][:amd64]                   = "http://peritor-assets.s3.amazonaws.com/ruby-enterprise_1.8.7-#{ruby_enterprise[:version]}_amd64.deb"
  else
    default[:ruby_enterprise][:version]                       = '2012.02'
    default[:ruby_enterprise][:url][:i386]                    = "http://peritor-assets.s3.amazonaws.com/ruby-enterprise_1.8.7-#{ruby_enterprise[:version]}_i386_ubuntu10.04.deb"
    default[:ruby_enterprise][:url][:amd64]                   = "http://peritor-assets.s3.amazonaws.com/ruby-enterprise_1.8.7-#{ruby_enterprise[:version]}_amd64_ubuntu10.04.deb"
  end
when 'centos','amazon','redhat','fedora','scientific','oracle'
  default[:ruby_enterprise][:pkgrelease]                      = '1'
  default[:ruby_enterprise][:version]                         = '1.8.7'
  default[:ruby_enterprise][:phusion_version]                 = '2012.02'
  default[:ruby_enterprise][:url][:i686]                      = "http://peritor-assets.s3.amazonaws.com/ruby-enterprise-#{node[:ruby_enterprise][:version]}-#{node[:ruby_enterprise][:phusion_version]}-#{node[:ruby_enterprise][:pkgrelease]}.i686.rpm"
  default[:ruby_enterprise][:url][:x86_64]                    = "http://peritor-assets.s3.amazonaws.com/ruby-enterprise-#{node[:ruby_enterprise][:version]}-#{node[:ruby_enterprise][:phusion_version]}-#{node[:ruby_enterprise][:pkgrelease]}.x86_64.rpm"
end

default[:ruby_enterprise][:gc][:heap_min_slots]           = 500000
default[:ruby_enterprise][:gc][:heap_slots_increment]     = 250000
default[:ruby_enterprise][:gc][:heap_slots_growth_factor] = 1
default[:ruby_enterprise][:gc][:malloc_limit]             = 50000000
default[:ruby_enterprise][:gc][:heap_free_min]            = 4096
