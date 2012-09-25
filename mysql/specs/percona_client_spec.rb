require 'minitest/spec'

describe_recipe 'mysql::percona_client' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'installs dependencies' do
    dependencies = []
    case node[:platform]
    when 'debian','ubuntu'
      dependencies = [ 'libdbi-perl', 'libplrpc-perl', 'libnet-daemon-perl' ]
    when 'centos','amazon','redhat','fedora','scientific','oracle'
      dependencies = [ 'perl-DBI', 'perl-Net-Daemon' ]
    end

    dependencies.each do |dep|
      package(dep).must_be_installed
    end
  end

  it 'installs percona client libraries' do
    case node[:platform]
    when 'debian','ubuntu'
      assert system('/usr/bin/dpkg -l | grep libmysqlclient1 && /usr/bin/dpkg -l | grep libmysqlclient-dev && /usr/bin/dpkg -l percona-server-client && /usr/bin/dpkg -l | grep percona-server-common'), "Percona client libraries were not installed"
    when 'centos','amazon','redhat','scientific','fedora','oracle'
      assert system('/bin/rpm -qa | grep Percona-Server-shared && /bin/rpm-qa | grep Percona-Server-client'), "Percona client libraries were not installed"
    end
  end
end
