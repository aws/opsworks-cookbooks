remote_file "/tmp/rubygems-#{node[:scalarium_rubygems][:version]}.tgz" do
  source "http://production.cf.rubygems.org/rubygems/rubygems-#{node[:scalarium_rubygems][:version]}.tgz"
  not_if do
    File.exists?("/tmp/rubygems-#{node[:scalarium_rubygems][:version]}.tgz")
  end
end

execute "tar xvfz rubygems-#{node[:scalarium_rubygems][:version]}.tgz" do
  cwd "/tmp"
  umask 022
  not_if do
    File.exists?("/tmp/rubygems-#{node[:scalarium_rubygems][:version]}")
  end
end

execute "Updating Rubygems to #{node[:scalarium_rubygems][:version]}" do
  command "/usr/local/bin/ruby setup.rb"
  cwd "/tmp/rubygems-#{node[:scalarium_rubygems][:version]}"
  umask 022
  not_if do
    File.exists?('/usr/local/bin/gem') && `/usr/local/bin/gem -v`.strip == node[:scalarium_rubygems][:version]
  end
end
