name        "opsworks_custom_cookbooks"
description "Supports custom user cookbooks"
maintainer  "AWS OpsWorks"
license     "Apache 2.0"
version     "1.0.0"

recipe "opsworks_custom_cookbooks::checkout", "Checkout custom Cookbooks"
recipe "opsworks_custom_cookbooks::load", "Load custom Cookbooks"
recipe "opsworks_custom_cookbooks::execute", "Execute custom Cookbooks"
recipe "opsworks_custom_cookbooks::update", "Update custom Cookbooks"
recipe "opsworks_custom_cookbooks::berkshelf", "Berkshelf Cookbooks management"

depends "scm_helper"
depends "opsworks_initial_setup"
depends "opsworks_commons"
depends "opsworks_berkshelf"

attribute "opsworks_custom_cookbooks/repository",
  :display_name => "URL to you Chef cookbooks",
  :description => "URL to you Chef cookbooks",
  :required => true,
  :type => 'string'
