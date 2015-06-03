# for backwards compatiblity default provider to mysql
default[:mysql][:provider] = "mysql" unless default[:mysql].key?(:provider)

case node[:platform]
when "redhat", "centos", "fedora", "amazon"
  package "#{node[:mysql][:provider]}-devel"
else "ubuntu"
  package "libmysqlclient-dev"
end

case node[:platform]
when "redhat", "centos", "fedora", "amazon"
  package node[:mysql][:provider]
else "ubuntu"
  package "mysql-client"
end
