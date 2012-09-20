class Apache2Test < MiniTest::Chef::TestCase
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  def test_apache2_package_existence
    package('apache2').must_be_installed
  end

  def test_apache2_log_directory_existence
    directory(node[:apache][:log_dir]).must_exist
  end

  def test_apache2_log_directory_permissions
    directory(node[:apache][:log_dir]).must_have(:mode, "0755")
  end

  def test_apache2_service_started
    service("apache2").must_be_running
  end

  def test_apache2_module_conf_generate_pl_existence
    assert File.exist?('/usr/local/bin/apache2_module_conf_generate.pl')
  end

  def test_apache2_debian_style_directories_existence_and_permissions
    %w{sites-available sites-enabled mods-available mods-enabled}.each do |dir|
      directory("#{node[:apache][:dir]}/#{dir}").must_exist
      directory("#{node[:apache][:dir]}/#{dir}").must_have(:mode, "0755").and(:owner, "root").and(:group, "root")
    end
  end

  def test_apache2_script_existence_and_permissions
    %w{a2ensite a2dissite a2enmod a2dismod}.each do |modscript|
      file("/usr/sbin/#{modscript}").must_exist.with(:owner, "root").and(:mode, "0755").and(:group, 'root")
    end
  end

  def test_apache2_ssl_directory_existence_and_permissions
    directory("#{node[:apache][:dir]}/ssl").must_exist.with(:mode, '0755').and(:owner, "root").and(:group, "root")
  end

  def test_apache2_httpd_conf_existence_and_permissions
    case node[:platform]
    when "centos","redhat","fedora","amazon"
      file("#{node[:apache][:dir]}/conf/httpd.conf").must_exist.with(:mode, "0644").and(:owner, "root").and(:group, "root")
    when "debian","ubuntu"
      file("#{node[:apache][:dir]}/apache2.conf").must_exist.with(:mode, "0644").and(:owner, "root").and(:group, "root")
    else
      # Fail the test - we want to make sure we're explicit with what
      # operating systems are supported by our tests.
      assert_equal(3, nil)
    end
  end

  def test_apache2_httpd_conf_check_correct_pid_file
    case node[:platform]
    when "centos","redhat","fedora","amazon"
      file("#{node[:apache][:dir]}/conf/httpd.conf").must_include "PidFile #{node[:apache][:pid_file]}"
    when "debian","ubuntu"
      file("#{node[:apache][:dir]}/apache2.conf").must_include "PidFile #{node[:apache][:pid_file]}"
    else
      # Fail the test - we want to make sure we're explicit with what
      # operating systems are supported by our tests.
      assert_equal(3, nil)
    end
  end

  def test_apache2_security_file_existence_and_permissions
    file("#{node[:apache][:dir]}/conf.d/security").must_exist.with(:mode, "0644").and(:owner, "root").and(:group, "root")
  end

  def test_apache2_charset_file_existence_and_permissions
    file("#{node[:apache][:dir]}/conf.d/charset").must_exist.with(:mode, "0644").and(:owner, "root").and(:group, "root")
  end

  def test_apache2_ports_conf_file_existence_and_permissions
    file("#{node[:apache][:dir]}/ports.conf").must_exist.with(:mode, "0644").and(:owner, "root").and(:group, "root")
  end

  def test_apache2_default_site_file_existence_and_permissions
    file("#{node[:apache][:dir]}/sites-available/default").must_exist.with(:mode, "0644").and(:owner, "root").and(:group, "root")
  end

  def test_apache2_docroot_index_html_must_not_exist
    file("#{node[:apache][:document_root]}/index.html").wont_exist
  end

  def access_apache2_over_tcp(host, port)
    refute_nil TCPSocket.new("#{host}", "#{port}"),
               "Apache is not accepting connections on #{host}:#{port}"
  end

  def test_apache2_access_via_tcp_on_127_0_0_1_port_80
    access_apache2_over_tcp('127.0.0.1', '80')
  end
end
