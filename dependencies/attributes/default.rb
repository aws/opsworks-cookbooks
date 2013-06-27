default[:dependencies][:gems] = {}
default[:dependencies][:debs] = {}
default[:dependencies][:npms] = {}
# this is not implemented on the application side.
default[:dependencies][:rpms] = {}

default[:dependencies][:update_debs] = false
default[:dependencies][:upgrade_debs] = false
# this is not implemented on the application side.
default[:dependencies][:upgrade_rpms] = false

default[:dependencies][:gem_binary] = "/usr/local/bin/gem"

default["dependencies"]["gem_uninstall_options"] = "--force --executables"
default["dependencies"]["gem_install_options"] = "--no-ri --no-rdoc"
