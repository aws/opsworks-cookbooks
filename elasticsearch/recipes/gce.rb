node.default[:elasticsearch][:plugin][:mandatory] = Array(node[:elasticsearch][:plugin][:mandatory] | ['cloud-gce'])

install_plugin "elasticsearch/elasticsearch-cloud-gce/#{node.elasticsearch['plugins']['elasticsearch/elasticsearch-cloud-gce']['version']}"
