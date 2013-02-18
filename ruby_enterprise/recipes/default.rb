case node[:platform]
when "debian","ubuntu"
  arch = RUBY_PLATFORM.match(/64/) ? 'amd64' : 'i386'

  remote_file File.join('/tmp', File.basename(node[:ruby_enterprise][:url][arch])) do
    source node[:ruby_enterprise][:url][arch]
    not_if { ::File.exists?(File.join('/tmp', File.basename(node[:ruby_enterprise][:url][arch]))) }
  end

  package "ruby1.9" do
    action :remove
    ignore_failure true
  end

  execute "Install Ruby Enterprise Edition" do
    cwd "/tmp"
    command "dpkg -i /tmp/#{File.basename(node[:ruby_enterprise][:url][arch])} && (/usr/local/bin/gem uninstall -a bundler || echo '1')"

    not_if do
      ::File.exists?("/usr/local/bin/ruby") &&
      system("/usr/local/bin/ruby -v | grep -q '#{node[:ruby_enterprise][:version]}$'")
    end
  end

  if node[:platform].eql?('ubuntu') && ['12.04'].include?("#{node[:platform_version]}")
    package 'libssl0.9.8'
  end
when 'centos','redhat','fedora','amazon'
  arch = node[:kernel][:machine]
  remote_file File.join('/tmp', File.basename(node[:ruby_enterprise][:url][arch])) do
    source node[:ruby_enterprise][:url][arch]
    not_if { ::File.exists?(File.join('/tmp', File.basename(node[:ruby_enterprise][:url][arch]))) }
  end

  package "ruby19" do
    action :remove
  end

  rpm_package 'ruby-enterprise' do
    source File.join('/tmp', File.basename(node[:ruby_enterprise][:url][arch]))
  end
end

template "/etc/environment" do
  source "environment.erb"
  mode "0644"
  owner "root"
  group "root"
end

template "/usr/local/bin/ruby_gc_wrapper.sh" do
  source "ruby_gc_wrapper.sh.erb"
  mode "0755"
  owner "root"
  group "root"
end

include_recipe 'opsworks_rubygems'
include_recipe 'opsworks_bundler'
