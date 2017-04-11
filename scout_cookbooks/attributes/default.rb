#
# See the README for a description of each attribute.
#

# required
default[:scout][:account_key] = nil

# optional
default[:scout][:hostname] = nil
default[:scout][:display_name] = nil
default[:scout][:log_file] = nil
default[:scout][:ruby_path] = nil
default[:scout][:environment] = nil
default[:scout][:roles] = nil
default[:scout][:agent_data_file] = nil
default[:scout][:version] = nil
default[:scout][:public_key] = nil
default[:scout][:http_proxy] = nil
default[:scout][:https_proxy] = nil
default[:scout][:delete_on_shutdown] = false	# create rc.d script to remove the server from scout on shutdown
default[:scout][:plugin_gems] = []   # list of gems to install to support plugins for role
default[:scout][:plugin_properties] = {}
