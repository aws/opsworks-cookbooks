# for backwards compatiblity default provider to mysql
default[:mysql][:provider] = "mysql" unless default[:mysql].key?(:provider)

service "mysql" do
  case node[:platform]
  when "redhat", "centos", "fedora", "amazon"
    if node[:mysql][:provider] == "mariadb"
      service_name "mariadb"
    else
      service_name "mysqld"
    end
  else
    service_name "mysql"
  end

  if platform?('ubuntu') && node[:platform_version].to_f >= 10.04
      provider Chef::Provider::Service::Upstart
  end
  supports :status => true, :restart => true, :reload => true
  action :nothing
end
