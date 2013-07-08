maintainer "Amazon Web Services"
description "Installs Rails"
version "0.1"
supports "ubuntu", ">= 8.10"

recipe "rails::configure", "Re-configure a Rails application"

depends "apache2"
depends "deploy"
depends "nginx"

attribute "rails",
  :display_name => "Rails",
  :description => "Hash of Rails attributes",
  :type => "hash"

attribute "rails/version",
  :display_name => "Rails Version",
  :description => "Specify the version of Rails to install",
  :default => "false"

attribute "rails/max_pool_size",
  :display_name => "Rails Max Pool Size",
  :description => "Specify the MaxPoolSize in the Apache vhost",
  :default => "4"
