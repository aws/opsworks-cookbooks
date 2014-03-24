###
# Do not use this file to override the dependencies cookbook's default
# attributes.  Instead, please use the customize.rb attributes file,
# which will keep your adjustments separate from the AWS OpsWorks
# codebase and make it easier to upgrade.
#
# However, you should not edit customize.rb directly. Instead, create
# "dependencies/attributes/customize.rb" in your cookbook repository and
# put the overrides in YOUR customize.rb file.
#
# Do NOT create an 'dependencies/attributes/default.rb' in your cookbooks. Doing so
# would completely override this file and might cause upgrade issues.
#
# See also: http://docs.aws.amazon.com/opsworks/latest/userguide/customizing.html
###

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

default["opsworks"] = {}
if node["opsworks"].has_key?("ruby_stack")
  case node["opsworks"]["ruby_stack"]
  when "ruby"
    include_attribute "ruby::ruby"
  end
end

include_attribute "opsworks_nodejs::opsworks_nodejs" if node["opsworks"].has_key?("instance") &&
                                                        node["opsworks"]["instance"].has_key?("layers") &&
                                                        node["opsworks"]["instance"]["layers"].include?("nodejs-app")

include_attribute "dependencies::customize"
