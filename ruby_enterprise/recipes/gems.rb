remote_file "/tmp/rubygems-#{node[:ruby_enterprise][:gems][:version]}.tgz" do
  source "http://production.cf.rubygems.org/rubygems/rubygems-#{node[:ruby_enterprise][:gems][:version]}.tgz"
  not_if do
    File.exists?("/tmp/rubygems-#{node[:ruby_enterprise][:gems][:version]}.tgz")
  end
end

execute "tar xvfz rubygems-#{node[:ruby_enterprise][:gems][:version]}.tgz" do
  cwd "/tmp"
  umask 022
  not_if do
    File.exists?("/tmp/rubygems-#{node[:ruby_enterprise][:gems][:version]}")
  end
end

execute "Updating Rubygems to #{node[:ruby_enterprise][:gems][:version]}" do
  command "/usr/local/bin/ruby setup.rb"
  cwd "/tmp/rubygems-#{node[:ruby_enterprise][:gems][:version]}"
  umask 022
  not_if do
    File.exists?('/usr/local/bin/gem') && `/usr/local/bin/gem -v`.strip == node[:ruby_enterprise][:gems][:version]
  end
end

gem_package "Installing Bundler #{node[:ruby_enterprise][:bundler][:version]}" do
  gem_binary node[:dependencies][:gem_binary]
  retries 2
  package_name "bundler"
  action :install
  version node[:ruby_enterprise][:bundler][:version]
end
