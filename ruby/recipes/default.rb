case node[:platform]
when 'debian','ubuntu'
  remote_file "/tmp/#{node[:ruby][:deb]}" do
    source node[:ruby][:deb_url]
    action :create_if_missing

    not_if do
      ::File.exists?("/usr/local/bin/ruby") &&
      system("/usr/local/bin/ruby -v | grep -q '#{node[:ruby][:version]}'")
    end
  end

  package "ruby-enterprise" do
    action :remove
    ignore_failure true
  end

when 'centos','redhat','fedora','amazon'
  remote_file "/tmp/#{node[:ruby][:rpm]}" do
    source node[:ruby][:rpm_url]
    action :create_if_missing

    not_if do
      ::File.exists?("/usr/local/bin/ruby") &&
      system("/usr/local/bin/ruby -v | grep -q '#{node[:ruby][:version]}'")
    end
  end
end

execute "Install Ruby #{node[:ruby][:full_version]}" do
  cwd "/tmp"
  case node[:platform]
  when 'centos','redhat','fedora','amazon'
    command "rpm -Uvh /tmp/#{node[:ruby][:rpm]}"
  when 'debian','ubuntu'
    command "dpkg -i /tmp/#{node[:ruby][:deb]}"
  end

  not_if do
    ::File.exists?("/usr/local/bin/ruby") &&
    system("/usr/local/bin/ruby -v | grep -q '#{node[:ruby][:version]}'")
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
