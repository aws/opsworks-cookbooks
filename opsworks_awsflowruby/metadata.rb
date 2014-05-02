name        "opsworks_awsflowruby"
description "Installs and configures AWS Flow for Ruby"
maintainer  "AWS OpsWorks"
license     "Apache 2.0"
version     "1.0.0"

# this for the ensure_scm_package_installed to get mixed in the recipe, so that opsworks_deploy finds it
# FIXME: should this really be necessary?
depends "scm_helper"
