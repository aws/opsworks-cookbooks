# for backwards compatiblity default the package name to mysql
mysql_name = node[:mysql][:name] || "mysql"

service "mysql" do
  case node[:platform]
  when "redhat", "centos", "fedora", "amazon"
    service_name "#{mysql_name}d"
  else
    service_name "mysql"
  end

  if platform?('ubuntu') && node[:platform_version].to_f >= 10.04
      provider Chef::Provider::Service::Upstart
  end
  supports :status => true, :restart => true, :reload => true
  action :nothing
end
