require "minitest/spec"

describe_recipe "mod_php5_apache2::default" do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it "installs a pile of php packages" do
    packages = case node[:platform_family]
               when "debian"
                [
                  "php5-xsl",
                  "php5-curl",
                  "php5-xmlrpc",
                  "php5-sqlite",
                  "php5-dev",
                  "php5-gd",
                  "php5-cli",
                  "php5-sasl",
                  "php5-mcrypt",
                  "php5-memcache",
                  "php-pear",
                  "php-xml-parser",
                  "php-mail-mime",
                  "php-db",
                  "php-mdb2",
                  "php-html-common"
                ]
              when "rhel"
                [
                  "php54-xml",
                  "php54-common",
                  "php54-xmlrpc",
                  "php54-devel",
                  "php54-gd",
                  "php54-cli",
                  "php-pear-Auth-SASL",
                  "php54-mcrypt",
                  "php54-pecl-memcache",
                  "php-pear",
                  "php-pear-XML-Parser",
                  "php-pear-Mail-Mime",
                  "php-pear-DB",
                  "php-pear-HTML-Common"
                ]
              end

    node[:deploy].each do |application, deploy|
      next unless deploy[:application_type] == "php"
      case node[:deploy][application][:database][:type]
      when "mysql"
        case node[:platform_family]
        when "debian"
          packages << "php5-mysql"
        when "rhel"
          packages << "php54-mysql"
        end
      when "postgresql"
        case node[:platform_family]
        when "debian"
          packages << "php5-pgsql"
        when "rhel"
          packages << "php54-pgsql"
        end
      end
    end

    packages.each do |pkg|
      package(pkg).must_be_installed
    end
  end
end
