require "minitest/spec"

describe_recipe "mod_php5_apache2::default" do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it "installs a pile of php packages" do
    packages = node[:mod_php5_apache2][:packages].dup

    node[:deploy].each do |application, deploy|
      next unless deploy[:application_type] == "php"
      case node[:deploy][application][:database][:type]
      when "mysql"
        case node[:platform_family]
        when "debian"
          packages << "php5-mysql"
        when "rhel"
          packages << "php-mysql"
        end
      when "postgresql"
        case node[:platform_family]
        when "debian"
          packages << "php5-pgsql"
        when "rhel"
          packages << "php-pgsql"
        end
      end
    end

    packages.each do |pkg|
      package(pkg).must_be_installed
    end
  end
end
