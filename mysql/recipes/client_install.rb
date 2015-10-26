# for backwards compatiblity default the package name to mysql
mysql_name = node[:mysql][:name] || "mysql"

case node[:platform]
when "redhat", "centos", "fedora", "amazon"
  if rhel7?
    # mysql55-mysql-devel package for Red Hat Enterprise Linux 7 is installed at /opt
    # compiling for example mysql gem will fail because it looks up wrong paths.
    # mariadb-devel is binary compatible and at correct location.
    package "mariadb-devel"
  else
    package "#{mysql_name}-devel"
  end
else # "ubuntu"
  package "libmysqlclient-dev"
end

case node[:platform]
when "redhat", "centos", "fedora", "amazon"
  package mysql_name
else "ubuntu"
  package "mysql-client"
end
