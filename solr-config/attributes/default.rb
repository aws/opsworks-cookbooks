default[:default][:staging][:solr_version] = "5.2.1"
default[:default][:staging][:root] = "/opt/solr-#{default[:default][:staging][:solr_version]}/server/"
default[:default][:staging][:solr_java_mem] = '-m 10g'


default[:default][:production][:solr_version] = "5.2.1"
default[:default][:production][:root] = "/opt/solr-#{default[:default][:production][:solr_version]}/server/"
default[:default][:production][:solr_java_mem] = '-m 10g'
