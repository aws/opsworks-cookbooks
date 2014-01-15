name        "memcached"
description "Installs Memcached"
maintainer  "AWS OpsWorks"
license     "Apache 2.0"
version     "1.0.0"

depends "opsworks_agent_monit"

recipe "memcached::server", "Memcached server"
recipe "memcached::ruby", "Memcached Ruby client libraries"
recipe "memcached::php", "Memcached PHP client libraries"

attribute "memcached/memory",
  :display_name => "Memcached Memory",
  :description => "Memory allocated for memcached instance",
  :default => "512"

attribute "memcached/port",
  :display_name => "Memcached Port",
  :description => "Port to use for memcached instance",
  :default => "11211"

attribute "memcached/user",
  :display_name => "Memcached User",
  :description => "User to run memcached instance as",
  :default => "nobody"
