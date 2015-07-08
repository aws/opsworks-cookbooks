default[:default][:staging][:solr_version] = "5.2.1"
default[:default][:staging][:root] = "/opt/solr-#{default[:default][:staging][:solr_version]}/server/"
default[:default][:staging][:solr_java_mem] = '-Xms512M -Xmx20480M'
