maintainer "Amazon Web Services"
description "Supports custom user cookbooks"
version "0.1"

depends "opsworks_initial_setup"
depends "scm_helper"

recipe "opsworks_custom_cookbooks::checkout", "Checkout custom Cookbooks"
recipe "opsworks_custom_cookbooks::load", "Load custom Cookbooks"
recipe "opsworks_custom_cookbooks::execute", "Execute custom Cookbooks"
recipe "opsworks_custom_cookbooks::update", "Update custom Cookbooks"

attribute "opsworks_custom_cookbooks/repository",
  :display_name => "URL to you Chef cookbooks",
  :description => "URL to you Chef cookbooks",
  :required => true
