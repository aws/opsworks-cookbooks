name        "opsworks_berkshelf"
description "Supports cookbooks management with berkshelf"
maintainer  "AWS OpsWorks"
license     "Apache 2.0"
version     "1.1.0"

recipe "opsworks_berkshelf::install", "Install berkshelf and managed cookbooks on the system."
recipe "opsworks_berkshelf::purge", "Remove berkshelf and managed cookbooks from system."

depends "opsworks_commons"
depends "scm_helper"
