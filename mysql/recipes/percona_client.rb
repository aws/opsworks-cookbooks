include_recipe "mysql::percona_repository"

# undeclared dependencies
if platform?('ubuntu','debian')
  package "libdbi-perl"
  package "libplrpc-perl"
  package "libnet-daemon-perl"
elsif platform?('centos','amazon','redhat','fedora','scientific','oracle')
  package "perl-DBI"
  # TODO: Find out whether there's a package for centos for PlRPC
  package "perl-Net-Daemon"
end

execute "Install Percona XtraDB client libraries" do
  cwd "#{node[:percona][:tmp_dir]}/#{node[:lsb][:release]}_#{node[:scalarium][:instance][:architecture]}"
  command value_for_platform(
    %w{debian ubuntu} => {
      'default' => "dpkg -i libmysqlclient1[68]* libmysqlclient-dev*  percona-server-client* percona-server-common*"
    },
    %w{centos amazon redhat fedora scientific oracle} => {
      'default' => "rpm -Uvh Percona-Server-shared-* Percona-Server-client-*"
    }
  )
end
