maintainer        "Amazon Web Services"
license           "Apache 2.0"
description       "Installs and configures MySQL"
version           "0.1"
recipe            "mysql::client", "Installs MySQL"
recipe            "mysql::server", "Installs MySQL"

['centos','redhat','fedora','amazon','debian','ubuntu'].each do |os|
  supports os
end
