#
# Cookbook Name:: dependencies
# Recipe:: default

include_recipe 'packages'
include_recipe 'gem_support'
include_recipe node[:opsworks][:ruby_stack]

case node[:platform]
when 'centos','redhat','fedora','amazon'
  # this should actually iterate over node[:dependencies][:rpms]
  node[:dependencies][:debs].each do |rpm, version|
    Chef::Log.info("preparing installation of dependency: rpm #{rpm.inspect}")
    package rpm do
      action :upgrade
      version(version)
      retries 3
      retry_delay 5
    end
  end
when 'debian','ubuntu'
  node[:dependencies][:debs].each do |deb, version|
    Chef::Log.info("preparing installation of dependency: dpkg #{deb.inspect}")
    package deb do
      action :upgrade
      version(version)
      retries 3
      retry_delay 5
    end
  end
end

node[:dependencies][:gems].each do |gem_name, version|
  Chef::Log.info("Preparing installation of dependency: Gem #{gem_name}")
  gem_package gem_name do
    version(version)
    retries 2
    gem_binary node[:dependencies][:gem_binary]
    options '--no-ri --no-rdoc'
  end
end

