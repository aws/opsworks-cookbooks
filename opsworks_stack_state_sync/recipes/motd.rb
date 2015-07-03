os_release =
  if node[:platform] == "redhat" && Chef::VersionConstraint.new("~> 7.0").include?(node["platform_version"])
    os_release = File.read("/etc/redhat-release").chomp
  else
    `head -1 /etc/issue | sed -e 's/ \\\\.*//'`.chomp
  end

template "/etc/motd.opsworks-static" do
  source "motd.erb"
  mode "0644"
  variables({
    :stack => node[:opsworks][:stack],
    :layers => node[:opsworks][:layers],
    :instance => node[:opsworks][:instance],
    :os_release => os_release
  })
end
