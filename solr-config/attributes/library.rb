default['library']['staging']['solr_version'] = "5.3.2-SNAPSHOT"
default['library']['staging']['path'] = "/opt/solr-#{default['library']['staging']['solr_version']}/server/"
default['library']['staging']['core_name'] = "library"

default['library']['production']['solr_version'] = "5.3.2-SNAPSHOT"
default['library']['production']['path'] = "/opt/solr-#{default['library']['staging']['solr_version']}/server/"
default['library']['production']['core_name'] = "library"
