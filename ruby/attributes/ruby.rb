include_attribute 'opsworks_initial_setup::default'
include_attribute 'opsworks_commons::default'

# ruby 1.8.7 is ruby-enterprise, os we don't handle it here
default[:ruby][:major_version] = '1.9'
default[:ruby][:full_version] = '1.9.3'
default[:ruby][:patch] = 'p392'
default[:ruby][:pkgrelease] = '1'

default[:ruby][:version] = "#{node[:ruby][:full_version]}#{node[:ruby][:patch]}"

arch = RUBY_PLATFORM.match(/64/) ? 'amd64' : 'i386'
default[:ruby][:deb] = "ruby#{node[:ruby][:major_version]}_#{node[:ruby][:full_version]}-#{node[:ruby][:patch]}.#{node[:ruby][:pkgrelease]}_#{arch}.deb"
default[:ruby][:deb_url] = "#{node[:opsworks_commons][:assets_url]}/packages/#{node[:platform]}/#{node[:platform_version]}/#{node[:ruby][:deb]}"

rhel_arch = RUBY_PLATFORM.match(/64/) ? 'x86_64' : 'i686'
default[:ruby][:rpm] = "ruby#{node[:ruby][:major_version].delete('.')}-#{node[:ruby][:full_version]}-#{node[:ruby][:patch]}-#{node[:ruby][:pkgrelease]}.#{rhel_arch}.rpm"
default[:ruby][:rpm_url] = "#{node[:opsworks_commons][:assets_url]}/packages/#{node[:platform]}/#{node[:platform_version]}/#{node[:ruby][:rpm]}"
