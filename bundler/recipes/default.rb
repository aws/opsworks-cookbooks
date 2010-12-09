remote_file "/tmp/rubygems-#{node[:bundler][:gems][:version]}.tgz" do
  source "http://production.cf.rubygems.org/rubygems/rubygems-#{node[:bundler][:gems][:version]}.tgz"
  not_if do
    File.exists?("/tmp/rubygems-#{node[:bundler][:gems][:version]}.tgz")
  end
end

execute "tar xvfz rubygems-#{node[:bundler][:gems][:version]}.tgz" do
  cwd "/tmp"
  umask 022
  not_if do
    File.exists?("/tmp/rubygems-#{node[:bundler][:gems][:version]}")
  end
end

execute "Updating Rubygems to #{node[:bundler][:gems][:version]}" do
  command "/usr/local/bin/ruby setup.rb"
  cwd "/tmp/rubygems-#{node[:bundler][:gems][:version]}"
  umask 022
  not_if do
    File.exists?('/usr/local/bin/gem') && `/usr/local/bin/gem -v`.strip == node[:bundler][:gems][:version]
  end
end

gem_package "Installing Bundler #{node[:bundler][:version]}" do
  gem_binary node[:dependencies][:gem_binary]
  retries 2
  package_name "bundler"
  action :install
  version node[:bundler][:version]
end
