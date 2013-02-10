include_attribute 'deploy'

default[:opsworks_nodejs][:version] = '0.6.1'
default[:opsworks_nodejs][:npm_version] = '1.0.105'
default[:opsworks_nodejs][:pkgrelease] = '1'
arch = RUBY_PLATFORM.match(/64/) ? 'amd64' : 'i386'
default[:opsworks_nodejs][:deb] = "nodejs_#{node[:opsworks_nodejs][:version]}-#{node[:opsworks_nodejs][:pkgrelease]}_#{arch}.deb"
default[:opsworks_nodejs][:deb_url] = "http://peritor-assets.s3.amazonaws.com/#{node[:platform]}/#{node[:platform_version]}/#{node[:opsworks_nodejs][:deb]}"

default[:opsworks_nodejs][:rpm] = "nodejs-#{node[:opsworks_nodejs][:version]}-#{node[:opsworks_nodejs][:pkgrelease]}.#{node[:kernel][:machine]}.rpm"

if node[:platform] == 'amazon'
  default[:opsworks_nodejs][:rpm_url] = "http://peritor-assets.s3.amazonaws.com/#{node[:platform]}/#{node[:opsworks_nodejs][:rpm]}"
else
  default[:opsworks_nodejs][:rpm_url] = "http://peritor-assets.s3.amazonaws.com/#{node[:platform]}/#{node[:platform_version]}/#{node[:opsworks_nodejs][:rpm]}"
end
