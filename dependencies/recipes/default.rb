#
# Cookbook Name:: dependencies
# Recipe:: default
#

include_recipe "packages"
include_recipe "gem_support"
include_recipe "ruby_enterprise"


node[:dependencies][:debs].each do |deb, version|
  Chef::Log.info("preparing installation of dependency: dpkg #{deb.inspect}")
  package deb do
    action :upgrade
    version(version)
  end
end

node[:dependencies][:gems].each do |gem_name, version|
  Chef::Log.info("Preparing installation of dependency: Gem #{gem_name}")

  gem_package gem_name do
    version(version)
    retries 2
    gem_binary node[:dependencies][:gem_binary]
    options "--no-ri --no-rdoc"
    only_if do
      raise "Could not find a candidate version to install for Gem: #{gem_name} - No such gem?" unless gem_available?(gem_name)
      if new_gem_version_available?(gem_name)
        Chef::Log.info("Installing new version of #{gem_name.inspect}")
        true
      end
    end
  end
end

