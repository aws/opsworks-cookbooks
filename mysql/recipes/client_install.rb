# for backwards compatiblity default the package name to mysql
mysql_name = node[:mysql][:name] || "mysql"

case node[:platform]
when "redhat", "centos", "fedora", "amazon"
  if rhel7?
    # mysql55-mysql-devel package for Red Hat Enterprise Linux 7 is installed at /opt
    # compiling for example mysql gem will fail because it looks up wrong paths.
    # mariadb-devel is binary compatible and at correct location.
    package "mariadb-devel" do
      retries 3
      retry_delay 5
    end
  else
    package "#{mysql_name}-devel" do
      retries 3
      retry_delay 5
    end
  end
else # "ubuntu"
  package "libmysqlclient-dev" do
    retries 3
    retry_delay 5
  end
end

package "mysql-client" do
  package_name value_for_platform_family(:rhel => mysql_name, :debian => "mysql-client")
  retries 3
  retry_delay 5
end
