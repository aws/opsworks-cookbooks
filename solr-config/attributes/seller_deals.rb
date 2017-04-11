default[:seller_deals ][:staging][:path] = "/opt/solr-5.2.1/server/solr"
default[:seller_deals ][:staging][:core_name] = "seller_deals"

default[:seller_deals ][:production][:path] = "/opt/solr-5.2.1/server/solr"
default[:seller_deals ][:production][:core_name] = "seller_deals"

default[:logrotate][:rotate] = 2
default[:logrotate][:dateformat] = false # set to '-%Y%m%d' to have date formatted logs  
