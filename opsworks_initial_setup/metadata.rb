name        "opsworks_initial_setup"
description "Initial Setup for EC2 instances"
maintainer  "AWS OpsWorks"
license     "Apache 2.0"
version     "1.0.0"

depends "opsworks_commons"

recipe "opsworks_initial_setup::sysctl", "Sets some sysctls to improve network performance"
recipe "opsworks_initial_setup::bind_mounts", "Set up some bind mounts for apps, logs & co"
