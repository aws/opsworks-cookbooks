#
# Cookbook Name:: dependencies
# Recipe:: default
#

include_recipe "packages"
include_recipe "gem_support"
include_recipe node[:scalarium][:ruby_stack]

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
  end
end

