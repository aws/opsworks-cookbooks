name        "rails"
description "Installs Rails"
maintainer  "AWS OpsWorks"
license     "Apache 2.0"
version     "1.0.0"

depends "apache2"
depends "deploy"
depends "nginx"

recipe "rails::configure", "Re-configure a Rails application"

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
