name             'opsworks_rabbitmq'
maintainer       'Andrew Jo'
maintainer_email 'andrew@verdigris.co'
license          'Simplified BSD'
description      'Wrapper cookbook for installing and configuring RabbitMQ on AWS OpsWorks instances'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.3.0'

%w(amazon debian ubuntu).each do |platform|
  supports platform
end

depends 'erlang', '>= 0.9'
depends 'rabbitmq', '~> 2.4'
