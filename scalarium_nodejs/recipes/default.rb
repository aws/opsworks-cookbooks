remote_file "/tmp/#{node[:scalarium_nodejs][:deb]}" do
  source node[:scalarium_nodejs][:deb_url]
  action :create_if_missing
end

execute "Install node.js #{node[:scalarium_nodejs][:version]}" do
  cwd "/tmp"
  command "dpkg -i /tmp/#{node[:scalarium_nodejs][:deb]}"

  not_if do
    ::File.exists?("/usr/local/bin/node") &&
    system("/usr/local/bin/node -v | grep -q '#{node[:scalarium_nodejs][:version]}'")
  end
end
