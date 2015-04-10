include_attribute 'elasticsearch::default'
include_attribute 'elasticsearch::plugins'

# Load configuration and credentials from data bag 'elasticsearch/gce' -
#
gce = Chef::DataBagItem.load('elasticsearch', 'gce')[node.chef_environment] rescue {}
# ----------------------------------------------------------------------

# To use the GCE discovery, you have to properly set up the configuration,
# either with the data bag, role or environment overrides, or directly
# on the node itself:
#
#    cloud:
#      gce:
#        project_id: <REPLACE>
#        zone: 		 <REPLACE>
#    discovery:
#      type: gce
#      gce:
#         tags: 	 <REPLACE>
#

default.elasticsearch['plugins']['elasticsearch/elasticsearch-cloud-gce']['version'] = '2.4.1'

# === GCE ===
# GCE configuration is set based on data bag values.
# You may choose to configure them in your node configuration instead.
#
default.elasticsearch[:discovery][:type]             = ( gce['discovery']['type']              rescue nil )
default.elasticsearch[:discovery][:gce][:tags]       = ( gce['discovery']['gce']['tags']       rescue nil )

default.elasticsearch[:cloud][:gce][:project_id]     = ( gce['cloud']['gce']['project_id']     rescue nil )
default.elasticsearch[:cloud][:gce][:zone]		     = ( gce['cloud']['gce']['zone']     	   rescue nil )

default.elasticsearch[:cloud][:node][:auto_attributes] = true
