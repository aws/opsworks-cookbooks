include_recipe "apache2"

packages = []

case node[:platform]
when 'debian','ubuntu'
  packages = [
    'php5-xsl', 
    'php5-curl',
    'php5-xmlrpc',
    'php5-sqlite',
    'php5-dev',
    'php5-gd',
    'php5-cli',
    'php5-sasl',
    'php5-mysql',
    'php5-mcrypt',
    'php5-memcache',
    'php-pear',
    'php-xml-parser',
    'php-mail-mime',
    'php-db',
    'php-mdb2',
    'php-html-common']

  if node[:platform] == 'ubuntu' && node[:platform_version] == '9.10'
    packages << 'php5-mhash'
  end
when 'centos','redhat','amazon','fedora','scientific','oracle'
  # TODO: Compile php-sqlite extension for RHEL based systems.
  packages = [
    'php-xml',
    'php-common',
    'php-xmlrpc',
    'php-devel',
    'php-gd',
    'php-cli',
    'php-pear-Auth-SASL',
    'php-mysql',
    'php-mcrypt',
    'php-pecl-memcache',
    'php-pear',
    'php-pear-XML-Parser',
    'php-pear-Mail-Mime',
    'php-pear-DB',
    'php-pear-HTML-Common']
end

packages.each do |pkg|
  package pkg do
    action :install
  end
end

include_recipe "apache2::mod_php5"
