class Apache2UninstallTest < MiniTest::Chef::TestCase
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  def test_apache2_service_stopped
    case node[:platform]
    when "debian","ubuntu"
      service("apache2").wont_be_running
    when "centos","redhat","amazon","fedora","scientific","oracle"
      service("httpd").wont_be_running
    else
      # Fail test if we don't have a supported OS.
      assert_equal(3, nil)
    end
  end

  def test_apache2_package_removed
    case node[:platform]
    when "debian","ubuntu"
      package("apache2").wont_be_installed
    when "centos","redhat","amazon","fedora","scientific","oracle"
      package("httpd").wont_be_installed
    else
      # Fail test if we don't have a supported OS.
      assert_equal(3, nil)
    end
  end
end
