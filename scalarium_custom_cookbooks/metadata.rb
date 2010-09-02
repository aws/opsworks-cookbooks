maintainer "Peritor GmbH"
maintainer_email "scalarium@peritor.com"
description "Supports custom user cookbooks"
version "0.1"

recipe "scalarium_custom_cookbooks::checkout", "Checkout custom Cookbooks"
recipe "scalarium_custom_cookbooks::load", "Load custom Cookbooks"
recipe "scalarium_custom_cookbooks::execute", "Execute custom Cookbooks"
recipe "scalarium_custom_cookbooks::update", "Update custom Cookbooks"

attribute "scalarium_custom_cookbooks/repository",
  :display_name => "URL to you Chef cookbooks",
  :description => "URL to you Chef cookbooks",
  :required => true,
  :type => 'string'