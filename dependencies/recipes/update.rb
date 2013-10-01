#
# Cookbook Name:: dependencies
# Recipe:: update

include_recipe 'packages'
include_recipe 'gem_support'

case node[:platform]
when 'centos','redhat','fedora','amazon'
  ruby_block "upgrade the release version lock" do
    block do
      rc = Chef::Util::FileEdit.new("/etc/yum.conf")
      release_line = "releasever=#{node[:dependencies][:os_release_version]}"
      rc.search_file_replace_line /^\s*releasever\s*=/, release_line
      rc.write_file
    end
    only_if do
      node[:dependencies][:os_release_version] && ::File.exists?("/etc/yum.conf")
    end
  end

  #if node[:dependencies][:upgrade_rpms] - not implemented in the application jet
  if node[:dependencies][:upgrade_debs]
    execute 'yum -y update' do
      action :run
    end
  end
when 'debian','ubuntu'
  if node[:dependencies][:update_debs]
    execute 'apt-get update' do
      action :run
    end
  end

  if node[:dependencies][:upgrade_debs]
    execute 'apt-get upgrade -y' do
      action :run
    end
  end
end
