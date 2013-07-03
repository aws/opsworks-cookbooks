include_attribute 'opsworks_initial_setup::default'
include_attribute 'opsworks_commons::default'

# ruby_version 1.8.7 is handled by 'ruby-enterprise'
case node["opsworks"]["ruby_version"]
when "2.0.0"
  default[:ruby][:major_version] = '2.0'
  default[:ruby][:full_version] = '2.0.0'
  default[:ruby][:patch] = 'p247'
  default[:ruby][:pkgrelease] = '1'
when "1.9.3"
  default[:ruby][:major_version] = '1.9'
  default[:ruby][:full_version] = '1.9.3'
  default[:ruby][:patch] = 'p448'
  default[:ruby][:pkgrelease] = '1'
else
  default[:ruby][:major_version] = ''
  default[:ruby][:full_version] = ''
  default[:ruby][:patch] = ''
  default[:ruby][:pkgrelease] = ''
end

default[:ruby][:version] = "#{node[:ruby][:full_version]}#{node[:ruby][:patch]}"

arch = RUBY_PLATFORM.match(/64/) ? 'amd64' : 'i386'
default[:ruby][:deb] = "ruby#{node[:ruby][:major_version]}_#{node[:ruby][:full_version]}-#{node[:ruby][:patch]}.#{node[:ruby][:pkgrelease]}_#{arch}.deb"
default[:ruby][:deb_url] = "#{node[:opsworks_commons][:assets_url]}/packages/#{node[:platform]}/#{node[:platform_version]}/#{node[:ruby][:deb]}"

rhel_arch = RUBY_PLATFORM.match(/64/) ? 'x86_64' : 'i686'
default[:ruby][:rpm] = "ruby#{node[:ruby][:major_version].delete('.')}-#{node[:ruby][:full_version]}-#{node[:ruby][:patch]}-#{node[:ruby][:pkgrelease]}.#{rhel_arch}.rpm"
default[:ruby][:rpm_url] = "#{node[:opsworks_commons][:assets_url]}/packages/#{node[:platform]}/#{node[:platform_version]}/#{node[:ruby][:rpm]}"
