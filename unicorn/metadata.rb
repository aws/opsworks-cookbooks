maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Manage unicorn"
version           "0.1"

%w{ ubuntu debian }.each do |os|
  supports os
end
