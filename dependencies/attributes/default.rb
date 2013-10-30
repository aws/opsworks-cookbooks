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

if node["opsworks"].has_key?("ruby_stack")
  case node["opsworks"]["ruby_stack"]
  when "ruby"
    include_attribute "ruby::ruby"
  when "ruby_enterprise"
    include_attribute "ruby_enterprise::ruby_enterprise"
  end
end

include_attribute "opsworks_nodejs::opsworks_nodejs" if node["opsworks"].has_key?("instance") &&
                                                        node["opsworks"]["instance"].has_key?("layers") &&
                                                        node["opsworks"]["instance"]["layers"].include?("nodejs-app")
