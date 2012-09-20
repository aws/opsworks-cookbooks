class Apache2UninstallTest < MiniTest::Chef::TestCase
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  def test_apache2_service_stopped
    service("apache2").wont_be_running
  end

  def test_apache2_package_removed
    package("apache2").wont_be_installed
  end
end
