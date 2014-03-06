include_attribute 'opsworks_initial_setup::default'

default[:opsworks_custom_cookbooks][:enabled] = false
default[:opsworks_custom_cookbooks][:user] = 'root'
default[:opsworks_custom_cookbooks][:group] = 'root'
default[:opsworks_custom_cookbooks][:home] = '/root'
default[:opsworks_custom_cookbooks][:destination] = ChefClientConfigSimpleParser.get_attribute(Chef::Config[:config_file], 'cookbook_path').select{|dir| dir =~ /site-cookbooks/}.first

default[:opsworks_custom_cookbooks][:recipes] = []

default[:opsworks_custom_cookbooks][:scm] = {}
default[:opsworks_custom_cookbooks][:scm][:type] = 'git'
default[:opsworks_custom_cookbooks][:scm][:user] = nil
default[:opsworks_custom_cookbooks][:scm][:password] = nil
default[:opsworks_custom_cookbooks][:scm][:ssh_key] = nil
default[:opsworks_custom_cookbooks][:scm][:repository] = nil

default[:opsworks_custom_cookbooks][:scm][:revision] = 'HEAD'
default[:opsworks_custom_cookbooks][:enable_submodules] = true

default[:opsworks_custom_cookbooks][:berkshelf_cookbook_path] = ChefClientConfigSimpleParser.get_attribute(Chef::Config[:config_file], 'cookbook_path').detect{|dir| dir =~ /berkshelf-cookbooks/}
default[:opsworks_custom_cookbooks][:berkshelf_version] = '2.0.14'
default[:opsworks_custom_cookbooks][:berkshelf_pkg_release] = '1'
default[:opsworks_custom_cookbooks][:berkshelf_binary] = '/opt/aws/opsworks/local/bin/berks'

case node[:platform]
when 'redhat', 'centos', 'fedora', 'amazon'
  arch = RUBY_PLATFORM.match(/64/) ? 'x86_64' : 'i686'
  default[:opsworks_custom_cookbooks][:berkshelf_package_file] = "berkshelf_#{node[:opsworks_custom_cookbooks][:berkshelf_version]}.rpm"
  default[:opsworks_custom_cookbooks][:berkshelf_package_url] = "https://s3.amazonaws.com/huesch-dummy/packages/amazon/2013.09/opsworks-berkshelf-#{node[:opsworks_custom_cookbooks][:berkshelf_version]}-#{node[:opsworks_custom_cookbooks][:berkshelf_pkg_release]}.#{arch}.rpm"
when 'ubuntu', 'debian'
  arch = RUBY_PLATFORM.match(/64/) ? 'amd64' : 'i386'
  default[:opsworks_custom_cookbooks][:berkshelf_package_file] = "berkshelf_#{node[:opsworks_custom_cookbooks][:berkshelf_version]}.deb"
  default[:opsworks_custom_cookbooks][:berkshelf_package_url] = "https://s3.amazonaws.com/huesch-dummy/packages/ubuntu/12.04/opsworks-berkshelf_#{node[:opsworks_custom_cookbooks][:berkshelf_version]}-#{node[:opsworks_custom_cookbooks][:berkshelf_pkg_release]}_#{arch}.deb"
end
