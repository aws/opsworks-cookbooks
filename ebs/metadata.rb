maintainer "Peritor GmbH"
maintainer_email "scalarium@peritor.com"
description "Mounts attached EBS volumes"
version "0.1"
#recipe "ebs", "Mounts attached EBS volumes"

attribute "ebs/devices",
  :display_name => "List of devices to mount",
  :description => "The list of devices to mount, e.g. /dev/sdh. The EBS volumes must already be attached.",
  :required => true,
  :type => "hash"