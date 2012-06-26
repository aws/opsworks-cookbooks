include_recipe "mysql::percona_repository"

# undeclared dependencies
package "libdbi-perl"
package "libplrpc-perl"
package "libnet-daemon-perl"

execute "Install Percona XtraDB client libraries" do
  cwd "#{node[:percona][:tmp_dir]}/#{node[:lsb][:release]}_#{node[:scalarium][:instance][:architecture]}"
  # rm libmysqlclient15 stuff. This brakes dependencies and to fix all packages is a PITA
  command "rm -f libmysqlclient15*; dpkg -i libmysqlclient* percona-server-client* percona-server-common*"
end
