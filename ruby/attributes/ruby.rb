# ruby 1.8.7 is ruby-enterprise, os we don't handle it here
case node['scalarium']['ruby_version']
when '1.9.2'
  default[:ruby][:major_version] = '1.9'
  default[:ruby][:full_version] = '1.9.2'
  default[:ruby][:patch] = 'p180'
  default[:ruby][:pkgrelease] = '3'
else
  default[:ruby][:major_version] = '1.9'
  default[:ruby][:full_version] = '1.9.3'
  default[:ruby][:patch] = 'p194'
  default[:ruby][:pkgrelease] = '1'
end

default[:ruby][:version] = "#{node[:ruby][:full_version]}#{node[:ruby][:patch]}"

# Ubuntu specific settings:

arch = RUBY_PLATFORM.match(/64/) ? 'amd64' : 'i386'
default[:ruby][:deb] = "ruby#{node[:ruby][:major_version]}_#{node[:ruby][:full_version]}-#{node[:ruby][:patch]}.#{node[:ruby][:pkgrelease]}_#{arch}.deb"
default[:ruby][:deb_url] = "http://peritor-assets.s3.amazonaws.com/#{node[:platform]}/#{node[:platform_version]}/#{node[:ruby][:deb]}"

# CentOS / Amazon Linux specific settings:

rhel_arch = RUBY_PLATFORM.match(/64/) ? 'x86_64' : 'i686'
default[:ruby][:rpm] = "ruby#{node[:ruby][:major_version].delete('.')}-#{node[:ruby][:full_version]}-#{node[:ruby][:patch]}-#{node[:ruby][:pkgrelease]}.#{rhel_arch}.rpm"
default[:ruby][:rpm_url] = "http://peritor-assets.s3.amazonaws.com/#{node[:platform]}/#{node[:platform_version]}/#{node[:ruby][:rpm]}"
