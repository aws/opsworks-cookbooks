maintainer       "Calogero Lo Leggio"
maintainer_email "kalos@nerdrug.org"
license          "Apache 2.0"
description      "Installs/Configures proftpd"
version          "0.2"

%w{ ubuntu debian }.each do |os|
  supports os
end

attribute "proftpd/dir",
  :display_name => "proftpd directory",
  :description => "Location of proftpd configuration files",
  :default => "/etc/proftpd"

attribute "proftpd/dir_extra_conf",
  :display_name => "proftpd extra conf directory",
  :description => "Sublocation of proftpd extra configuration files",
  :default => "conf.d"

attribute "proftpd/modules",
  :display_name => "proftpd modules",
  :description => "proftpd supported modules",
  :type => "array",
  :default => [ "ctrls", "ctrls_admin", "ban", "load", "dynmasq", "ifsession", "quotatab_file", "wrap", "wrap2", "wrap2_file", "rewrite", "tls", "sql_mysql" ]

attribute "proftpd/nat",
  :display_name => "toggle nat",
  :description => "insert IP of natted server",
  :default => "off"
