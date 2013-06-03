maintainer "Amazon Web Services"
description "Initial Setup for EC2 instances"
version "0.1"

depends "opsworks_commons"

recipe "opsworks_initial_setup::sysctl", "Sets some sysctls to improve network performance"
recipe "opsworks_initial_setup::bind_mounts", "Set up some bind mounts for apps, logs & co"
