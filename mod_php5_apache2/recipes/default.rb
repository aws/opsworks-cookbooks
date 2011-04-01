include_recipe "apache2"

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

packages.each do |deb|
  package deb do
    action :install
  end
end

include_recipe "apache2::mod_php5"