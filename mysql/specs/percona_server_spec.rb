require 'minitest/spec'

describe_recipe 'mysql::percona_server' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'installs dependencies' do
    skip unless ['debian','ubuntu'].include?(node[:platform])
    package('libaio1').must_be_installed
  end

  it 'fixes percona issues if platform is ubuntu and is lucid or newer' do
    skip unless node[:platform] == 'ubuntu' && node[:platform_version].to_f >= 10.04
    if File.directory?('/etc/init') && !File.exists?('/etc/init/mysql.conf')
      file('/etc/init/mysql.conf').must_exist.with(:mode, '644').and(:owner, 'root').and(:group, 'root')
    end

    link('/etc/init.d/mysql').must_exist.with(:link_type, :symbolic).and(:to, '/lib/init/upstart-job')
  end

  it 'installs percona packages' do
    case node[:platform]
    when 'debian','ubuntu'
      assert system('/usr/bin/dpkg -l | grep percona-server-server'), "Percona was not installed"
    when 'centos','amazon','redhat','scientific','oracle'
      assert system('/bin/rpm -qa | grep Percona-Server-server && /bin/rpm -qa | grep Percona-Server-shared'), "Percona was not installed"
    end
  end
end
