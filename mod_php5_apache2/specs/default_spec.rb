require 'minitest/spec'

describe_recipe 'mod_php5_apache2::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'installs a pile of php packages' do
    case node[:platform_family]
    when "debian"
      packages = [
        'php5-xsl',
        'php5-curl',
        'php5-xmlrpc',
        'php5-sqlite',
        'php5-dev',
        'php5-gd',
        'php5-cli',
        'php5-sasl',
        'php5-mcrypt',
        'php5-memcache',
        'php-pear',
        'php-xml-parser',
        'php-mail-mime',
        'php-db',
        'php-mdb2',
        'php-html-common'
      ]

      node[:deploy].each do |_, deploy|
        next if deploy[:application_type] != "php" || deploy[:database][:type].nil?
        if deploy[:database][:type] == "postgresql"
          packages << "php5-pgsql"
        else
          packages << "php5-mysql"
        end
      end

    when "rhel"
      packages = [
        'php-xml',
        'php-common',
        'php-xmlrpc',
        'php-devel',
        'php-gd',
        'php-cli',
        'php-pear-Auth-SASL',
        'php-mcrypt',
        'php-pecl-memcache',
        'php-pear',
        'php-pear-XML-Parser',
        'php-pear-Mail-Mime',
        'php-pear-DB',
        'php-pear-HTML-Common'
      ]

      node[:deploy].each do |_, deploy|
        next if deploy[:application_type] != "php" || deploy[:database][:type].nil?
        if deploy[:database][:type] == "postgresql"
          packages << "php-pgsql"
        else
          packages << "php-mysql"
        end
      end

    end

    packages.each do |pkg|
      package(pkg).must_be_installed
    end
  end
end
