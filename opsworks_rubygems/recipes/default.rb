rubygems_download = remote_file "/tmp/rubygems-#{node[:opsworks_rubygems][:version]}.tgz" do
  source "http://production.cf.rubygems.org/rubygems/rubygems-#{node[:opsworks_rubygems][:version]}.tgz"
  not_if do
    ::File.exists?('/usr/local/bin/gem') && `/usr/local/bin/gem -v`.strip == node[:opsworks_rubygems][:version]
  end
end

fallback "rubygems download fallback" do
  resource rubygems_download
  fallback_options [
    {:source => "#{node[:opsworks_commons][:assets_url]}/rubygems-#{node[:opsworks_rubygems][:version]}.tgz"}
  ]
end

execute "tar xfz rubygems-#{node[:opsworks_rubygems][:version]}.tgz" do
  cwd "/tmp"
  umask 022
  only_if do
    ::File.exists?("/tmp/rubygems-#{node[:opsworks_rubygems][:version]}.tgz")
  end
end

execute "Updating Rubygems to #{node[:opsworks_rubygems][:version]}" do
  command node[:opsworks_rubygems][:setup_command]
  cwd "/tmp/rubygems-#{node[:opsworks_rubygems][:version]}"
  umask 022
  only_if do
    ::File.exists?("/tmp/rubygems-#{node[:opsworks_rubygems][:version]}")
  end
end

execute "Clean up" do
  command "rm -rf rubygems-#{node[:opsworks_rubygems][:version]}*"
  cwd "/tmp"
end
