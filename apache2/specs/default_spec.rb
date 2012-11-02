require 'minitest/spec'

describe_recipe 'apache2::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  describe 'packages' do
    it 'installs the apache2 package' do
      case node[:platform]
      when 'debian','ubuntu'
        package('apache2').must_be_installed
      when 'centos','redhat','fedora','amazon'
        package('httpd').must_be_installed
      else
        fail_test "Your OS (#{node[:platform]}) is not supported."
      end
    end
  end

  describe 'directories' do
    it 'ensures the log directory exists' do
      directory(node[:apache][:log_dir]).must_exist
    end

    it 'ensures the log directory has the right permissions' do
      directory(node[:apache][:log_dir]).must_have(:mode, '755')
    end

    it 'creates debian style folders for apache2' do
      ['sites-available','sites-enabled','mods-available','mods-enabled'].each do |dir|
        directory("#{node[:apache][:dir]}/#{dir}").must_exist
        directory("#{node[:apache][:dir]}/#{dir}").must_have(:mode, '755').and(
                  :owner, 'root').and(:group, 'root')
      end
    end

    it 'creates the ssl directory for apache2' do
      directory("#{node[:apache][:dir]}/ssl").must_exist.with(:mode, '755').and(
                :owner, 'root').and(:group, 'root')
    end
  end

  describe 'services' do
    it 'starts and enables the apache2 service' do
      case node[:platform]
      when 'debian','ubuntu'
        service('apache2').must_be_enabled
        service('apache2').must_be_running
      when 'centos','redhat','fedora','amazon'
        service('httpd').must_be_enabled
        service('httpd').must_be_running
      else
        fail_test "Your OS (#{node[:platform]}) is not supported."
      end
    end
  end

  describe 'files' do
    it 'creates the apache2_module_conf_generate.pl script' do
      skip unless ['centos', 'redhat', 'fedora', 'amazon'].include?(node[:platform])
      file('/usr/local/bin/apache2_module_conf_generate.pl').must_exist
    end

    it 'creates debian apache2 scripts for managing sites and modules' do
      ['a2ensite','a2dissite','a2enmod','a2dismod'].each do |modscript|
        file("/usr/sbin/#{modscript}").must_exist.with(:owner, 'root').and(
             :mode, '755').and(:group, 'root')
      end
    end

    it 'creates apache2 configuration file with the right permissions' do
      case node[:platform]
      when 'centos','redhat','fedora','amazon'
        file("#{node[:apache][:dir]}/conf/httpd.conf").must_exist.with(
             :mode, '644').and(:owner, 'root').and(:group, 'root')
      when 'debian','ubuntu'
        file("#{node[:apache][:dir]}/apache2.conf").must_exist.with(
             :mode, '644').and(:owner, 'root').and(:group, 'root')
      else
        # Fail the test - we want to make sure we're explicit with what
        # operating systems are supported by our tests.
        fail_test "Your OS (#{node[:platform]}) is not supported."
      end
    end

    it 'writes the apache2 configuration file with the correct pid file location' do
      case node[:platform]
      when 'centos','redhat','fedora','amazon'
        file("#{node[:apache][:dir]}/conf/httpd.conf").must_include "PidFile #{node[:apache][:pid_file]}"
      when 'debian','ubuntu'
        file("#{node[:apache][:dir]}/apache2.conf").must_include "PidFile #{node[:apache][:pid_file]}"
      else
        fail_test "Your OS (#{node[:platform]}) is not supported."
      end
    end

    it 'creates the apache2 security file with the correct permissions' do
      file("#{node[:apache][:dir]}/conf.d/security").must_exist.with(:mode, '644').and(
           :owner, 'root').and(:group, 'root')
    end

    it 'creates the apache2 charset file with the correct permissions' do
      file("#{node[:apache][:dir]}/conf.d/charset").must_exist.with(:mode, '644').and(
           :owner, 'root').and(:group, 'root')
    end

    it 'creates the apache2 ports.conf file with the correct permissions' do
      file("#{node[:apache][:dir]}/ports.conf").must_exist.with(:mode, '644').and(
           :owner, 'root').and(:group, 'root')
    end

    it 'creates the default apache2 site file' do
      file("#{node[:apache][:dir]}/sites-available/default").must_exist.with(:mode, '644').and(
           :owner, 'root').and(:group, 'root')
    end

    it 'removes the default index.html file in the docroot' do
      file("#{node[:apache][:document_root]}/index.html").wont_exist
    end
  end

  describe 'networking' do
    it 'should be accessible over localhost:80' do
      access_apache2_over_tcp('127.0.0.1', '80')
    end
  end

  def access_apache2_over_tcp(host, port)
    refute_nil TCPSocket.new("#{host}", "#{port}"),
               "Apache is not accepting connections on #{host}:#{port}"
  end

  def fail_test(msg = nil)
    assert_equal(3, nil, msg)
  end
end
