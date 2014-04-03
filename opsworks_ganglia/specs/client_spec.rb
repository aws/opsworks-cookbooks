require 'minitest/spec'

describe_recipe 'opsworks_ganglia::client' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  before :all do
    @monitoring_master = node[:opsworks][:layers].has_key?('monitoring-master')
  end

  it 'installs ganglia monitor deamon' do
    package_name = case node[:platform_family]
    when 'debian'
      'ganglia-monitor'
    when "rhel"
      'ganglia-gmond'
    end

    if @monitoring_master
      package(package_name).must_be_installed
    else
      package(package_name).wont_be_installed
    end
  end

  it 'creates /etc/ganglia/scripts directory' do
    if @monitoring_master
      directory('/etc/ganglia/scripts').must_exist.with(:owner, 'root').and(:group, 'root').and(:mode, '755')
    else
      directory('/etc/ganglia/scripts').wont_exist
    end
  end

  it 'creates /etc/ganglia/conf.d' do
    if @monitoring_master
      directory('/etc/ganglia/conf.d').must_exist.with(:owner, 'root').and(:group, 'root').and(:mode, '755')
    else
      directory('/etc/ganglia/conf.d').wont_exist
    end
  end

  it 'creates /etc/ganglia/python_modules' do
    if @monitoring_master
      link('/etc/ganglia/python_modules').must_exist.with(:link_type, :symbolic).and(:to,
        case node[:platform]
        when 'debian','ubuntu'
          "/usr/lib/ganglia/python_modules"
        when 'centos','redhat','fedora','amazon'
          "/usr/lib#{RUBY_PLATFORM[/64/]}/ganglia/python_modules"
        end
      )
    else
      link('/etc/ganglia/python_modules').wont_exist
    end
  end
end
