# for backwards compatiblity default provider to mysql
db_provider = node[:mysql][:provider] || "mysql"

service "mysql" do
  case node[:platform]
  when "redhat", "centos", "fedora", "amazon"
    if db_provider  == "mariadb"
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
