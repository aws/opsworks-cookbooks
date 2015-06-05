# for backwards compatiblity default provider to mysql
db_provider = node[:mysql][:provider] || "mysql"

case node[:platform]
when "redhat", "centos", "fedora", "amazon"
  package "#{db_provider}-devel"
else "ubuntu"
  package "libmysqlclient-dev"
end

case node[:platform]
when "redhat", "centos", "fedora", "amazon"
  package db_provider
else "ubuntu"
  package "mysql-client"
end
