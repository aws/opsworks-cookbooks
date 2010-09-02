maintainer "Peritor GmbH"
maintainer_email "scalarium@peritor.com"
description "Maintains the Scalarium state file"
version "0.1"

attribute "scalarium_cluster_state/path",
  :display_name => "Path to the state file",
  :description => "Path to the Scalarium state file",
  :required => true,
  :type => 'string'