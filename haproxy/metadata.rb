maintainer        'Opscode, Inc.'
maintainer_email  'cookbooks@opscode.com'
license           'Apache 2.0'
description       'Installs and configures haproxy'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           '0.7'
recipe 'haproxy', 'Install and configure a HAProxy instance'
recipe 'haproxy::configure', 'reconfigure and restart HAProxy'

['debian','ubuntu'].each do |os|
  supports os
end

attribute 'haproxy/backend',
  :display_name => 'Backend',
  :description => 'List of backend services to load balance',
  :required => true,
  :type => 'array'
