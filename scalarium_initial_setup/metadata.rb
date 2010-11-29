maintainer "Peritor GmbH"
maintainer_email "scalarium@peritor.com"
description "Initial Setup for EC2 instances"
version "0.1"

recipe "scalarium_initial_setup::sysctl", "Sets some sysctls to improve network performance"
recipe "scalarium_initial_setup::bind_mounts", "Set up some bind mounts for apps, logs & co"