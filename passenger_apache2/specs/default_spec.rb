require 'minitest/spec'

describe_recipe 'passenger_apache2::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  describe 'distribution packages only' do
    it 'installs rubygem-passenger package if RHEL based' do
      skip unless node[:packages][:dist_only]
      package('rubygem-passenger').must_be_installed
    end
  end

  describe 'compilation is allowed' do
    it 'installs devel packages for building rubygem-passenger' do
      skip unless node[:packages][:dist_only]
      case node[:platform]
      when 'centos','redhat','amazon'
        package('httpd-devel').must_be_installed
        if node['platform_version'].to_f < 6.0
          package('curl-devel').must_be_installed
        else
          package('libcurl-devel').must_be_installed
          package('openssl-devel').must_be_installed
          package('zlib-devel').must_be_installed
        end
      else
        package('apache2-prefork-dev').must_be_installed
        package('libapr1-dev').must_be_installed
        if node[:passenger][:version] >= '3.0.0'
          package('libcurl4-openssl-dev').must_be_installed
        end
      end
    end

    it 'ensures only defined passenger version is installed' do
      assert system("test `#{node[:dependencies][:gem_binary]} list passenger | grep passenger | wc -l` -eq 1 && #{node[:dependencies][:gem_binary]} list passenger | grep '#{node[:passenger][:version]}'")
    end

    it 'installs apache2 passenger module' do
      file(node[:passenger][:module_path]).must_exist
    end
  end
end
