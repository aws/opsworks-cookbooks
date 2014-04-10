require 'minitest/spec'

describe_recipe 'opsworks_ganglia::client' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'installs ganglia monitor deamon' do
    package_name = case node[:platform_family]
    when 'debian'
      'ganglia-monitor'
    when "rhel"
      'ganglia-gmond'
    end
    package(package_name).must_be_installed
  end

  it 'creates /etc/ganglia/scripts directory' do
    directory('/etc/ganglia/scripts').must_exist.with(:owner, 'root').and(:group, 'root').and(:mode, '755')
  end

  it 'creates /etc/ganglia/conf.d' do
    directory('/etc/ganglia/conf.d').must_exist.with(:owner, 'root').and(:group, 'root').and(:mode, '755')
  end

  it 'creates /etc/ganglia/python_modules' do
    link('/etc/ganglia/python_modules').must_exist.with(:link_type, :symbolic).and(:to,
      case node[:platform]
      when 'debian','ubuntu'
        "/usr/lib/ganglia/python_modules"
      when 'centos','redhat','fedora','amazon'
        "/usr/lib#{RUBY_PLATFORM[/64/]}/ganglia/python_modules"
      end
    )
  end
end
