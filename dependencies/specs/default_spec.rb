require 'minitest/spec'

describe_recipe 'dependencies::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'should upgrade all OS dependencies to the required version' do
    packages = {}
    case node[:platform]
    when 'debian','ubuntu'
      packages = node[:dependencies][:debs]
    when 'centos','redhat','fedora','amazon'
      #packages = node[:dependencies][:rpms] - not implemented on the application
      packages = node[:dependencies][:debs]
    end

    packages.each do |pkg, version|
      unless version.nil?
        package(pkg).must_be_installed.with(:version, version)
      else
        package(pkg).must_be_installed
      end
    end
  end

  it 'should upgrade all gem files to the required version' do
    node[:dependencies][:gems].each do |gem_name, version|
      assert system("#{node[:dependencies][:gem_binary]} list | grep '#{gem_name}' | \
                    grep '#{version}'"), "#{gem_name} (#{version}) was not installed."
    end
  end
end
