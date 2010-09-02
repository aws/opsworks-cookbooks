maintainer        "Peritor GmbH"
maintainer_email  "scalarium@peritor.com"
license           "Apache 2.0"
description       "Installs and configures MySQL and XtraDB"
version           "0.1"
recipe            "mysql::client", "Installs MySQL or XtraDB client"
recipe            "mysql::server", "Installs MySQL or XtraDB server"
recipe            "mysql::percona_client", "Installs XtraDB client"
recipe            "mysql::percona_server", "Installs XtraDB server"
recipe            "mysql::percona_repository", "Downloads XtraDB packages"

%w{ debian ubuntu }.each do |os|
  supports os
end