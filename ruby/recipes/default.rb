# remove installed version if it's no the one we want to install
# enables updating stack from ruby 1.9 to ruby 2.0
# currently we only support one user sapce ruby installation

local_ruby_up_to_date = ::File.exists?(node[:ruby][:executable]) &&
                        system("#{node[:ruby][:executable]} -v | grep '#{node['ruby']['version']}' > /dev/null 2>&1") &&
                        if ['debian','ubuntu'].include?(node[:platform])
                          system("dpkg --get-selections | grep -v deinstall | grep 'opsworks-ruby' > /dev/null 2>&1")
                        else
                          system("rpm -qa | grep 'opsworks-ruby' > /dev/null 2>&1")
                        end

if local_ruby_up_to_date
  Chef::Log.info("Userspace Ruby version is #{node['ruby']['version']} - up-to-date")
elsif !::File.exists?(node[:ruby][:executable])
  Chef::Log.info("Userspace Ruby version is not #{node['ruby']['version']} - #{node[:ruby][:executable]} does not exist")
else
  Chef::Log.info("Userspace Ruby version is not #{node['ruby']['version']} - found #{`#{node[:ruby][:executable]} -v`}")
end

case node['platform']
when 'debian','ubuntu'
  remote_file "/tmp/#{node[:ruby][:deb]}" do
    source node[:ruby][:deb_url]
    action :create_if_missing

    not_if do
      local_ruby_up_to_date
    end
  end

  ['opsworks-ruby1.9','opsworks-ruby2.0','ruby-enterprise','ruby1.9','ruby2.0'].each do |pkg|
    package pkg do
      action :remove
      ignore_failure true

      only_if do
       ::File.exists?("/tmp/#{node['ruby']['deb']}")
      end
    end
  end

when 'centos','redhat','fedora','amazon'
  remote_file "/tmp/#{node[:ruby][:rpm]}" do
    source node[:ruby][:rpm_url]
    action :create_if_missing

    not_if do
      local_ruby_up_to_date
    end
  end

  ['opsworks-ruby1.9','opsworks-ruby2.0','ruby-enterprise','ruby19','ruby20'].each do |pkg|
    package pkg do
      action :remove
      ignore_failure true

      only_if do
        ::File.exists?("/tmp/#{node['ruby']['rpm']}")
      end
    end
  end
end

execute "Install Ruby #{node[:ruby][:full_version]}" do
  cwd "/tmp"
  case node[:platform]
  when 'centos','redhat','fedora','amazon'
    command "rpm -Uvh /tmp/#{node['ruby']['rpm']}"
    only_if do
      ::File.exists?("/tmp/#{node['ruby']['rpm']}")
    end

  when 'debian','ubuntu'
    command "dpkg -i /tmp/#{node['ruby']['deb']}"
    only_if do
      ::File.exists?("/tmp/#{node['ruby']['deb']}")
    end
  end
end

execute 'Delete downloaded ruby packages' do
  command "rm -vf /tmp/#{node[:ruby][:deb]} /tmp/#{node[:ruby][:rpm]}"
  only_if do
     ::File.exists?("/tmp/#{node[:ruby][:deb]}") ||
     ::File.exists?("/tmp/#{node[:ruby][:rpm]}")
   end
end

include_recipe 'opsworks_rubygems'
include_recipe 'opsworks_bundler'
