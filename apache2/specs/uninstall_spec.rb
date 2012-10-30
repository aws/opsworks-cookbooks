require 'minitest/spec'

describe_recipe 'apache2::uninstall' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'should stop apache2' do
    case node[:platform]
    when 'debian','ubuntu'
      service('apache2').wont_be_running
    when 'centos','redhat','fedora','amazon'
      service('httpd').wont_be_running
    else
      # Fail test if we don't have a supported OS.
      assert_equal(3, nil)
    end
  end

  it 'should remove the apache2 package' do
    case node[:platform]
    when 'debian','ubuntu'
      package('apache2').wont_be_installed
    when 'centos','redhat','fedora','amazon'
      package('httpd').wont_be_installed
    else
      # Fail test if we don't have a supported OS.
      assert_equal(3, nil)
    end
  end
end
