###
# Do not use this file to override the mod_php5_apache2 cookbook's default
# attributes.  Instead, please use the customize.rb attributes file,
# which will keep your adjustments separate from the AWS OpsWorks
# codebase and make it easier to upgrade.
#
# However, you should not edit customize.rb directly. Instead, create
# "mod_php5_apache2/attributes/customize.rb" in your cookbook repository and
# put the overrides in YOUR customize.rb file.
#
# Do NOT create an 'mod_php5_apache2/attributes/default.rb' in your cookbooks. Doing so
# would completely override this file and might cause upgrade issues.
#
# See also: http://docs.aws.amazon.com/opsworks/latest/userguide/customizing.html
###

packages = []

case node[:platform_family]
when 'debian'
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
when 'rhel'
  packages = [
    'php54-xml',
    'php54-common',
    'php54-xmlrpc',
    'php54-devel',
    'php54-gd',
    'php54-cli',
    'php-pear-Auth-SASL',
    'php54-mcrypt',
    'php54-pecl-memcache',
    'php-pear',
    'php-pear-XML-Parser',
    'php-pear-Mail-Mime',
    'php-pear-DB',
    'php-pear-HTML-Common'
  ]
end

default[:mod_php5_apache2][:packages] = packages

include_attribute "mod_php5_apache2::customize"
