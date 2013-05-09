remote_file "/tmp/rubygems-#{node[:opsworks_rubygems][:version]}.tgz" do
  source "http://production.cf.rubygems.org/rubygems/rubygems-#{node[:opsworks_rubygems][:version]}.tgz"
  not_if do
    File.exists?("/tmp/rubygems-#{node[:opsworks_rubygems][:version]}.tgz")
  end
end

execute "tar xvfz rubygems-#{node[:opsworks_rubygems][:version]}.tgz" do
  cwd "/tmp"
  umask 022
  not_if do
    File.exists?("/tmp/rubygems-#{node[:opsworks_rubygems][:version]}")
  end
end

execute "Updating Rubygems to #{node[:opsworks_rubygems][:version]}" do
  command "/usr/local/bin/ruby setup.rb --no-rdoc --no-ri"
  cwd "/tmp/rubygems-#{node[:opsworks_rubygems][:version]}"
  umask 022
  not_if do
    File.exists?('/usr/local/bin/gem') && `/usr/local/bin/gem -v`.strip == node[:opsworks_rubygems][:version]
  end
end
