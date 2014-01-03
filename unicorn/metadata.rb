maintainer        "AWS OpsWorks"
license           "Apache 2.0"
description       "Manage unicorn"
version           "0.1"

['centos','redhat','fedora','amazon','debian','ubuntu'].each do |os|
  supports os
end
