###
# Do not use this file to override the opsworks_custom_cookbooks cookbook's default
# attributes.  Instead, please use the customize.rb attributes file,
# which will keep your adjustments separate from the AWS OpsWorks
# codebase and make it easier to upgrade.
#
# However, you should not edit customize.rb directly. Instead, create
# "opsworks_custom_cookbooks/attributes/customize.rb" in your cookbook repository and
# put the overrides in YOUR customize.rb file.
#
# Do NOT create an 'opsworks_custom_cookbooks/attributes/default.rb' in your cookbooks. Doing so
# would completely override this file and might cause upgrade issues.
#
# See also: http://docs.aws.amazon.com/opsworks/latest/userguide/customizing.html
###

include_attribute 'opsworks_initial_setup::default'

default[:opsworks_custom_cookbooks][:enabled] = false
default[:opsworks_custom_cookbooks][:user] = 'root'
default[:opsworks_custom_cookbooks][:group] = 'root'
default[:opsworks_custom_cookbooks][:home] = '/root'
normal[:opsworks_custom_cookbooks][:destination] = OpsworksInstanceAgentConfig.site_cookbooks_path

default[:opsworks_custom_cookbooks][:recipes] = []

default[:opsworks_custom_cookbooks][:scm] = {}
default[:opsworks_custom_cookbooks][:scm][:type] = 'git'
default[:opsworks_custom_cookbooks][:scm][:user] = nil
default[:opsworks_custom_cookbooks][:scm][:password] = nil
default[:opsworks_custom_cookbooks][:scm][:ssh_key] = nil
default[:opsworks_custom_cookbooks][:scm][:repository] = nil

default[:opsworks_custom_cookbooks][:scm][:revision] = 'HEAD'
default[:opsworks_custom_cookbooks][:enable_submodules] = true

default[:opsworks_custom_cookbooks][:berkshelf_cookbooks_path] = OpsworksInstanceAgentConfig.berkshelf_cookbooks_path
default[:opsworks_custom_cookbooks][:berkshelf_version] = '2.0.14'
if node[:opsworks_custom_cookbooks][:berkshelf_version].to_i >= 3
  default[:opsworks_custom_cookbooks][:berkshelf_command] = "vendor #{node[:opsworks_custom_cookbooks][:berkshelf_cookbooks_path]}"
else
  default[:opsworks_custom_cookbooks][:berkshelf_command] = "install --path #{node[:opsworks_custom_cookbooks][:berkshelf_cookbooks_path]}"
end

default[:opsworks_custom_cookbooks][:berkshelf_pkg_release] = '1'
default[:opsworks_custom_cookbooks][:berkshelf_binary] = '/opt/aws/opsworks/local/bin/berks'

default[:opsworks_custom_cookbooks][:gem_binary] = '/opt/aws/opsworks/local/bin/gem'
default[:opsworks_custom_cookbooks][:gem_uninstall_options] = '--force --executables'

case node[:platform]
when 'redhat', 'centos', 'fedora', 'amazon'
  arch = RUBY_PLATFORM.match(/64/) ? 'x86_64' : 'i686'
  default[:opsworks_custom_cookbooks][:berkshelf_package_file] = "berkshelf_#{node[:opsworks_custom_cookbooks][:berkshelf_version]}.rpm"
  default[:opsworks_custom_cookbooks][:berkshelf_package_url] = "#{node[:opsworks_commons][:assets_url]}/packages/#{node[:platform]}/#{node[:platform_version]}/opsworks-berkshelf-#{node[:opsworks_custom_cookbooks][:berkshelf_version]}-#{node[:opsworks_custom_cookbooks][:berkshelf_pkg_release]}.#{arch}.rpm"
when 'ubuntu', 'debian'
  arch = RUBY_PLATFORM.match(/64/) ? 'amd64' : 'i386'
  default[:opsworks_custom_cookbooks][:berkshelf_package_file] = "berkshelf_#{node[:opsworks_custom_cookbooks][:berkshelf_version]}.deb"
  default[:opsworks_custom_cookbooks][:berkshelf_package_url] = "#{node[:opsworks_commons][:assets_url]}/packages/#{node[:platform]}/#{node[:platform_version]}/opsworks-berkshelf_#{node[:opsworks_custom_cookbooks][:berkshelf_version]}-#{node[:opsworks_custom_cookbooks][:berkshelf_pkg_release]}_#{arch}.deb"
end

include_attribute "opsworks_custom_cookbooks::customize"
