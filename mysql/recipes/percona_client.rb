include_recipe "mysql::percona_repository"

# undeclared dependencies
package "libdbi-perl"
package "libplrpc-perl"
package "libnet-daemon-perl"

execute "Install Percona XtraDB client libraries" do
  cwd "#{node[:percona][:tmp_dir]}/#{node[:lsb][:release]}_#{node[:scalarium][:instance][:architecture]}"
  command "dpkg -i libmysqlclient1[68]* libmysqlclient-dev*  percona-server-client* percona-server-common*"
end
