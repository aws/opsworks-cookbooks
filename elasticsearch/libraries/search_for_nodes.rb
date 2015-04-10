module Extensions

  # Search for other Elasticsearch nodes
  #
  # The `search_for_nodes()` method will use Chef Search to find other nodes matching a search query
  # (skipping the current node) and will return a sorted array of hostnames, defaulting to a smart
  # selection between `node['ipaddress']` and `node['cloud']['local_ipv4']`.
  #
  # If a search query is provided, that will be used instead of the default.
  #
  # Examples:
  #
  # Search using tags instead of roles:
  #
  #     search_for_nodes("tag:es-logstash AND chef_environment:#{node.chef_environment}")
  #
  # Search using multiple roles:
  #
  #     search_for_nodes("(role:es-master OR role:es-peer) AND chef_environment:#{node.chef_environment}")
  #
  # If a node attribute is provided, it will be used instead of smart selection.
  #
  # Examples:
  #
  # Use the FQDN from each node:
  #
  #     search_for_nodes(query, 'fqdn')
  #
  # Use the public interface for each node:
  #
  #     search_for_nodes(query, 'cloud.public_ipv4)
  #
  def search_for_nodes(query = nil, attribute = nil)
    nodes = find_matching_nodes(query)
    nodes.map do |node|
      select_attribute(node, attribute)
    end.sort
  end

  def find_matching_nodes(query = nil)
    query ||= "roles:elasticsearch AND chef_environment:#{node.chef_environment} AND elasticsearch_cluster_name:#{node[:elasticsearch][:cluster][:name]}"
    results = []
    Chef::Log.debug("Searching for nodes with query: \"#{query}\"")
    Chef::Search::Query.new.search(:node, query) { |o| results << o }
    results
  end

  def select_attribute(node, attribute = nil)
    if attribute
      # iterates through keys seperated by '.', eg
      # 'foo.bar.baz' => node['foo']['bar']['baz']
      keys = attribute.split('.')
      value = node
      keys.each do |key|
        value = value[key]
      end
      Chef::Log.debug("Selected attribute: #{attribute.inspect} for node: #{node.name.inspect} with value: #{value.inspect}")
      value
    else
      if node.has_key? 'cloud' and node['cloud'].has_key? 'local_ipv4'
        value = node['cloud']['local_ipv4']
        Chef::Log.debug("Selected attribute: \"cloud.local_ipv4\" for node: #{node.name.inspect} with value: #{value.inspect}")
        value
      else
        value = node['ipaddress']
        Chef::Log.debug("Selected attribute: \"ipaddress\" for node: #{node.name.inspect} with value: #{value.inspect}")
        value
      end
    end
  end
end
