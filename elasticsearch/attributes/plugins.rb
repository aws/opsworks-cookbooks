Chef::Log.debug "Attempting to load plugin list from the databag..."

plugins = Chef::DataBagItem.load('elasticsearch', 'plugins')[node.chef_environment].to_hash['plugins'] rescue {}

node.default.elasticsearch[:plugins].merge!(plugins)
node.default.elasticsearch[:plugin][:mandatory] = []

Chef::Log.debug "Plugins list: #{default.elasticsearch.plugins.inspect}"
