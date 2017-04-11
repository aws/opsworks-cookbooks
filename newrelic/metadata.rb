name 'newrelic'
maintainer 'Escape Studios'
maintainer_email 'dev@escapestudios.com'
license 'MIT'
description 'Installs/Configures New Relic'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '2.11.2'

%w( debian ubuntu redhat centos fedora scientific amazon windows smartos oracle ).each do |os|
  supports os
end

depends 'python'
depends 'curl'
depends 'apt', '~> 2.0'
depends 'yum', '~> 3.0'

recipe 'newrelic', 'Adds the New Relic repository, installs & configures the New Relic server monitor agent.'
recipe 'newrelic::repository', 'Adds the New Relic repository.'
recipe 'newrelic::server_monitor_agent', 'Installs & configures the New Relic server monitor agent.'
recipe 'newrelic::dotnet_agent', 'Installs New Relic .NET agent.'
recipe 'newrelic::java_agent', 'Installs the New Relic Java agent.'
recipe 'newrelic::nodejs_agent', 'Installs New Relic Node.js agent.'
recipe 'newrelic::php_agent', 'Installs the New Relic PHP agent.'
recipe 'newrelic::python_agent', 'Installs the New Relic Python agent.'
recipe 'newrelic::ruby_agent', 'Installs the New Relic Ruby agent.'
