name        "mysql"
description "Installs and configures MySQL"
maintainer  "AWS OpsWorks"
license     "Apache 2.0"
version     "1.0.0"

recipe "mysql::client", "Installs MySQL"
recipe "mysql::server", "Installs MySQL"
