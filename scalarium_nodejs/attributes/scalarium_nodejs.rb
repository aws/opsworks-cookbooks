include_attribute 'deploy'

default[:scalarium_nodejs][:version] = '0.6.1'
default[:scalarium_nodejs][:npm_version] = '1.0.105'
default[:scalarium_nodejs][:pkgrelease] = '1'
arch = RUBY_PLATFORM.match(/64/) ? 'amd64' : 'i386'
default[:scalarium_nodejs][:deb] = "nodejs_#{node[:scalarium_nodejs][:version]}-#{node[:scalarium_nodejs][:pkgrelease]}_#{arch}.deb"
default[:scalarium_nodejs][:deb_url] = "http://peritor-assets.s3.amazonaws.com/#{node[:platform]}/#{node[:platform_version]}/#{node[:scalarium_nodejs][:deb]}"
