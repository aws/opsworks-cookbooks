include_recipe 'opsworks_java::jvm_install'
include_recipe 'praga-solr-opsworks-cookbook::solr'
include_recipe 'praga-solr-opsworks-cookbook::config'
include_recipe 'praga-solr-opsworks-cookbook::crond'
