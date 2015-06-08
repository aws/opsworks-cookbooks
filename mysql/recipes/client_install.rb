# for backwards compatiblity default the package name to mysql
mysql_name = node[:mysql][:name] || "mysql"

case node[:platform]
when "redhat", "centos", "fedora", "amazon"
  package "#{mysql_name}-devel"
else "ubuntu"
  package "libmysqlclient-dev"
end

case node[:platform]
when "redhat", "centos", "fedora", "amazon"
  package mysql_name
else "ubuntu"
  package "mysql-client"
end
