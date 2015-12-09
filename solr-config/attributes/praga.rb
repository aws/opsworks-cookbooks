default[:praga][:staging][:path] = "/opt/solr-5.2.1/server/solr"
default[:praga][:staging][:core_name] = "praga"


default[:praga][:production][:path] = "/opt/solr-5.2.1/server/solr"
default[:praga][:production][:core_name] = "praga"


default[:logrotate][:rotate] = 2
default[:logrotate][:dateformat] = false # set to '-%Y%m%d' to have date formatted logs
  
