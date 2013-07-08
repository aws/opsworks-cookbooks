maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs passenger for Apache2"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.11"

%w{ packages gem_support apache2 nginx unicorn rails }.each do |cb|
  depends cb
end

%w{ redhat centos amazon ubuntu debian }.each do |os|
  supports os
end

attribute "passenger/version",
  :display_name => "Passenger Version",
  :description => "Version of Passenger to install",
  :default => "2.2.11"

attribute "passenger/root_path",
  :display_name => "Passenger Root Path",
  :description => "Location of passenger installed gem",
  :default => "gem_dir/gems/passenger-passenger_version"

attribute "passenger/module_path",
  :display_name => "Passenger Module Path",
  :description => "Location of the compiled Apache module",
  :default => "passenger_root_path/ext/apache2/mod_passenger.so"
  
attribute "passenger/ruby_bin",
  :display_name => "Passenger Ruby Path",
  :description => "Location of the Ruby binary to use",
  :default => "/usr/bin/local/ruby"
  
attribute "passenger/gem_bin",
  :display_name => "Passenger Gem Path",
  :description => "Location of the Gem binary to use",
  :default => "/usr/bin/local/gem"

