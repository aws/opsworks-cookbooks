maintainer "Amazon Web Services"
description "Install .gem and .deb depencencies"
version "0.1"
depends "packages"
depends "gem_support"
depends "ruby_enterprise"
depends "ruby"

recipe "dependencies::update", "Update all packages and gems"

attribute "dependencies/gems",
  :display_name => "Gems to install",
  :description => "A list of Rubygems to install",
  :required => false

attribute "dependencies/debs",
  :display_name => "Debian packages to install",
  :description => "A list of Debian packages (.deb) to install",
  :required => false

attribute "dependencies/update_debs",
  :display_name => "Update sources",
  :description => "Update sources using apt-get update",
  :required => false

attribute "dependencies/upgrade_debs",
  :display_name => "Update packages",
  :description => "Update packages using apt-get upgrade",
  :required => false

attribute "dependencies/upgrade_gems",
  :display_name => "Update gems",
  :description => "Update gems using gem update",
  :required => false
