default[:ruby][:major_version] = '1.9'
default[:ruby][:full_version] = '1.9.2'
default[:ruby][:patch] = 'p180'
default[:ruby][:pkgrelease] = '3'
default[:ruby][:version] = "#{node[:ruby][:full_version]}#{node[:ruby][:patch]}"
arch = RUBY_PLATFORM.match(/64/) ? 'amd64' : 'i386'
default[:ruby][:deb] = "ruby#{node[:ruby][:major_version]}_#{node[:ruby][:full_version]}-#{node[:ruby][:patch]}.#{node[:ruby][:pkgrelease]}_#{arch}.deb"
default[:ruby][:deb_url] = "http://peritor-assets.s3.amazonaws.com/#{node[:platform]}/#{node[:platform_version]}/#{node[:ruby][:deb]}"
